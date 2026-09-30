function Weapon_ProtoBuster() : Weapon() constructor {
    #region Static Data
    
    // == Base Weapon Statics ==
	
	static id = WeaponType.BUSTER_PROTO;
	static flags = WeaponFlags.NO_AMMO | WeaponFlags.CHARGE;
	
	// == Buster-Specific Statics ==
	
	static chargePreDuration = 20;
	static chargeDuration = 57;
	static chargeColoursOutline = [ $000000, $CC00D8 ];
	static chargeColoursFull = [ $00B5F7, $73F7D6, $007BAD ];
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 1;
	iconColours =  [ $0028DC, $BCBCBC, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Proto Buster";
	shortName = "P.Buster";
	
	// - Shot Data
	shotData.set_shot_object(objProtoShot)
		.set_shot_limit(3, [ objProtoShot, objProtoShotHalfCharge, objProtoShotCharged ])
		.set_shoot_animation(PlayerShootType.SHOOT)
		.set_auto_shoot_delay(8);
	
	// == Buster-Specific Variables ==
	
	chargeState = 0; // 0 - not charging; 1 - pre charging; 2 - charging; 3 - fully charged;
	chargeTimer = 0;
	chargeToggle = false;
	barAmount = 0;
	
	playerRef = noone; // Reference to the player using this weapon
	hudRef = undefined; // Reference to the player's HUD element, if they have one
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		self.handle_charge_state();
		chargeTimer++;
		hudRef.weaponVisible = options_data().chargeBar;
		hudRef.weaponAmmo = barAmount;
	};
	
	static on_equip = function(_player) {
		barAmount = 0;
		chargeToggle = false;
		self.change_charge_state(0);
		
		playerRef = _player;
		hudRef = playerRef.hudElement;
		hudRef.weaponVisible = options_data().chargeBar;
		hudRef.weaponAmmo = 0;
	};
	
	static on_unequip = function(_player) {
		stop_sfx(sfxChargingProto);
		
		with (playerRef)
			isCharging = false;
		playerRef = noone;
		hudRef = undefined;
	};
	
	#endregion

    #region Functions - Charging
	
	static change_charge_state = function(_newState) {
		chargeState = _newState;
		chargeTimer = -1;
	};
	
	static handle_charge_state = function() {
		playerRef.isCharging = (chargeState >= 2);
        
        switch (chargeState) {
			case 0: // No Charge
				barAmount = 0;
				
				if (playerRef.check_input_shoot())
					self.fire_buster_shot(0);
				else if (!playerRef.isShooting && self.player_can_charge())
					self.change_charge_state(1);
				break;
            
            case 1: // Pre Charge
				barAmount = 0;
				
				if (!self.player_can_charge())
					self.change_charge_state(0);
				else if (chargeTimer >= chargePreDuration)
					self.change_charge_state(2);
				break;
			
			case 2: // Charging
				if (chargeTimer == 0)
					play_sfx(sfxChargingProto);
				
				var _index = (chargeTimer <= (chargeDuration >> 1))
					? (chargeTimer mod 8 <= 4)
					: (chargeTimer mod 4 <= 2);
				self.update_player_colour(PalettePlayer.outline, chargeColoursOutline[_index]);
				
				barAmount = remap(0, chargeDuration, 0, 28, chargeTimer);
				
				if (!self.player_can_charge() || (chargeToggle && playerRef.inputs.is_pressed(InputActions.SHOOT))) {
					if (playerRef.is_action_locked(PlayerAction.SHOOT))
						self.clear_charge();
					else
						self.fire_buster_shot(1);
				} else if (chargeTimer >= chargeDuration) {
					self.change_charge_state(3);
				}
				break;
			
			case 3: // Fully Charged
				switch (chargeTimer mod 8) {
					case 0:
					case 4:
						playerRef.refresh_palette();
						break;
					case 2:
						self.update_player_colour(PalettePlayer.outline, chargeColoursOutline[1]);
						break;
					case 6:
						for (var i = 0; i < 3; i++)
							self.update_player_colour(i, chargeColoursFull[i]);
						break;
				}
				
				if (!self.player_can_charge() || (chargeToggle && playerRef.inputs.is_pressed(InputActions.SHOOT))) {
					if (playerRef.is_action_locked(PlayerAction.SHOOT))
						self.clear_charge();
					else
						self.fire_buster_shot(2);
				}
				break;
        }
	}
	
	#endregion
	
	#region Functions - Other
	
	static clear_charge = function() {
		stop_sfx(sfxChargingProto);
		self.change_charge_state(0);
		playerRef.refresh_palette();
		playerRef.isCharging = false;
	};
	
	static fire_buster_shot = function(_chargeLevel) {
		var _shotObject = objProtoShot,
			_offsetX = 0,
			_moveSpeed = 5,
			_sfx = sfxBuster;
		
		if (_chargeLevel == 1) {
			_shotObject = objProtoShotHalfCharge;
			_offsetX = -4;
			_sfx = sfxBusterHalfCharge;
		} else if (_chargeLevel >= 2) {
			_shotObject = objProtoShotCharged;
			_offsetX = 4;
			_moveSpeed = 5.5;
			_sfx = sfxBusterCharged;
		}
		
		shotData.set_shot_object(_shotObject);
		shotData.set_spawn_offset(_offsetX, 0);
		
		var _shot = playerRef.fire_weapon(shotData);
		if (_shot != noone) {
			_shot.xspeed = _moveSpeed * playerRef.image_xscale;
			chargeToggle = (_chargeLevel <= 0 && playerRef.is_user_controlled() && options_data().chargeToggle);
			play_sfx(_sfx);
		}
		
		self.clear_charge();
	};
	
	static player_can_charge = function() {
		if (playerRef.is_action_locked(PlayerAction.CHARGE))
			return false;
		
		var _chargeToggle = playerRef.is_user_controlled() ? options_data().autoFire : false;
		return _chargeToggle
			? chargeToggle
			: playerInputs.is_held(InputActions.SHOOT);
	};
	
	static update_player_colour = function(_index, _colour) {
		playerRef.palette.set_output_colour_at(_index, _colour);
		hudRef.weaponPalette[_index] = _colour;
	};
	
	#endregion
}
