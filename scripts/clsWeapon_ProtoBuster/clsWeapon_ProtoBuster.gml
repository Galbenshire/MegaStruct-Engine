function Weapon_ProtoBuster() : Weapon() constructor {
    #region Static Data
    
    // == Base Weapon Statics ==
	
	static id = WeaponType.BUSTER_PROTO;
	static colours =  [ $0028DC, $BCBCBC, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	static flags = WeaponFlags.NO_AMMO | WeaponFlags.CHARGE;
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 1;
	
	// - Name
	static name = "Proto Buster";
	static shortName = "P.Buster";
	
	// == Buster-Specific Statics ==
	
	static chargePreDuration = 20;
	static chargeDuration = 57;
	static chargeColoursOutline = [ $000000, $CC00D8 ];
	static chargeColoursFull = [ $00B8F8, $A8E0FC, $5878F8 ];
	
	#endregion
	
	#region Variables
	
	chargeState = 0; // 0 - not charging; 1 - pre charging; 2 - charging; 3 - fully charged;
	chargeTimer = 0;
	chargeToggle = false;
	barAmount = 0;
	
	__player = noone;
	__hudElement = undefined;
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		handle_charge_state();
		chargeTimer++;
		
		if (!is_undefined(__hudElement)) {
			__hudElement.ammoVisible = options_data().chargeBar;
			__hudElement.ammo = barAmount;
		}
	};
	
	static on_equip = function(_player) {
		barAmount = 0;
		chargeToggle = false;
		
		change_charge_state(0);
		
		__player = _player;
		if (is_player_controlled(__player))
			__hudElement = __player.playerUser.hudElement;
	};
	
	static on_unequip = function(_player) {
		stop_sfx(sfxCharging);
		stop_sfx(sfxCharged);
		__player.isCharging = false;
		__player = noone;
		__hudElement = undefined;
	};
	
	#endregion

    #region Functions - Charging
	
	static change_charge_state = function(_newState) {
		chargeState = _newState;
		chargeTimer = -1;
	};
	
	static handle_charge_state = function() {
		__player.isCharging = (chargeState >= 2);
        
        switch (chargeState) {
			case 0: // No Charge
				barAmount = 0;
				
				if (player_shot_input(, __player))
					fire_buster_shot(0);
				else if (!__player.isShooting && player_can_charge())
					change_charge_state(1);
				break;
            
            case 1: // Pre Charge
				barAmount = 0;
				
				if (!player_can_charge())
					change_charge_state(0);
				else if (chargeTimer >= chargePreDuration)
					change_charge_state(2);
				break;
			
			case 2: // Charging
				if (chargeTimer == 0)
					play_sfx(sfxChargingProto);
				
				var _index = (chargeTimer <= (chargeDuration * 0.5))
					? (chargeTimer mod 8 <= 4)
					: (chargeTimer mod 4 <= 2);
				update_player_colour(PalettePlayer.outline, chargeColoursOutline[_index]);
				
				barAmount = remap(0, chargeDuration, 0, 28, chargeTimer);
				
				if (!player_can_charge() || (chargeToggle && __player.inputs.is_pressed(InputActions.SHOOT))) {
					if (!player_is_action_locked(PlayerAction.SHOOT, __player))
						fire_buster_shot(1);
				} else if (chargeTimer >= chargeDuration) {
					change_charge_state(3);
				}
				break;
			
			case 3: // Fully Charged
				var _chargeCycle = chargeTimer mod 6;
				if (_chargeCycle == 0) {
					player_refresh_palette(__player);
				} else if (_chargeCycle == 2) {
					update_player_colour(PalettePlayer.outline, chargeColoursOutline[(chargeTimer mod 16) < 8]);
				} else if (_chargeCycle == 4) {
					for (var i = 0; i < 3; i++)
						update_player_colour(i, chargeColoursFull[i]);
				}
				
				if (!player_can_charge() || (chargeToggle && __player.inputs.is_pressed(InputActions.SHOOT))) {
					if (!player_is_action_locked(PlayerAction.SHOOT, __player))
						fire_buster_shot(2);
				}
				break;
        }
	}
	
	#endregion
	
	#region Functions - Other
	
	static fire_buster_shot = function(_chargeLevel) {
		with (__player) {
			var _moveSpeed = 5,
				_sfx = sfxBuster;
			var _shotData = {
				object: objProtoShot,
				limit: 3,
				cost: 0,
				shootAnimation: 1,
				autoShootDelay: 8
			};
			
			if (_chargeLevel == 1) {
				_shotData.object = objProtoShotHalfCharge;
				_shotData.offsetX = -4;
				_sfx = sfxBusterHalfCharge;
			} else if (_chargeLevel >= 2) {
				_shotData.object = objProtoShotCharged;
				_shotData.offsetX = 4;
				_moveSpeed = 5.5;
				_sfx = sfxBusterCharged;
			}
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = _moveSpeed * image_xscale;
				play_sfx(_sfx);
				other.__chargeToggle = (_chargeLevel <= 0 && options_data().chargeToggle);
			}
			
			stop_sfx(sfxChargingProto);
			player_refresh_palette();
			isCharging = false;
			other.change_charge_state(0);
		}
	};
	
	static player_can_charge = function() {
		if (player_is_action_locked(PlayerAction.SHOOT, __player))
			return false;
		
		return options_data().chargeToggle
			? chargeToggle
			: __player.inputs.is_held(InputActions.SHOOT);
	};
	
	static update_player_colour = function(_index, _colour) {
		__player.palette.set_colour_at(_index, _colour);
		if (!is_undefined(__hudElement))
			__hudElement.ammoPalette[_index] = _colour;
	};
	
	#endregion
}