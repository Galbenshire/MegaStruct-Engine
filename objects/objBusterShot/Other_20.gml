/// @description Weapon Setup
global.weaponList[WeaponType.BUSTER] = new Weapon(WeaponType.BUSTER);
with (global.weaponList[WeaponType.BUSTER]) {
	object = objBusterShot;
	set_name("Mega Buster");
	set_icon(sprWeaponIcons, 1);
	flags = WeaponFlags.NO_AMMO | WeaponFlags.CHARGE;
	
	// -- Top: NES
    // -- Bottom: MM9 & 10
    //colours = [ $EC7000, $D8E800 ];
    colours = [ $EC7000, $F8B838 ];
    
    onTick = function(_player) {
		__handle_charge_state();
		__chargeTimer++;
		
		if (!is_undefined(__hudElement)) {
			__hudElement.ammoVisible = options_data().chargeBar;
			__hudElement.ammo = __barAmount;
		}
	};
	
	onEquip = function(_player) {
		__player = _player;
		__barAmount = 0;
		__chargeToggle = false;
		__change_charge_state(0);
		
		if (is_player_controlled(__player))
			__hudElement = __player.playerUser.hudElement;
	};
	
	onUnequip = function(_player) {
		stop_sfx(sfxCharging);
		stop_sfx(sfxCharged);
		__player.isCharging = false;
		__player = noone;
		__hudElement = undefined;
	};
	
	// == Weapon Specific ==
	
	// - Constants (in spirit)
	
	__preChargeDuration = 20;
	__chargeDuration = 56;
	__outlineChargeColours = [ $000000, $2000A8, $5800E4, $9858F8 ];
	__fullChargeColours = [ colours[PaletteWeapon.primary], colours[PaletteWeapon.secondary], $000000 ];
	
	// - Variables
	
	__chargeState = 0; // 0 - not charging; 1 - pre charging; 2 - charging; 3 - fully charged;
	__chargeTimer = 0;
	__barAmount = 0;
	__chargeToggle = false;
	
	// - References
	
	__player = noone;
	__hudElement = undefined;
	
	// - Functions -- Charge State
	
	__change_charge_state = function(_newState) {
		__chargeState = _newState;
		__chargeTimer = -1;
	};
	
	__handle_charge_state = function() {
		__player.isCharging = (__chargeState >= 2);
		
		switch (__chargeState) {
			case 0: // No Charge
				__barAmount = 0;
				
				if (player_can_fire_shot(__player))
					__fire_buster_shot(0);
				else if (!__player.isShooting && __player_can_charge())
					__change_charge_state(1);
				break;
			
			case 1: // Pre Charge
				__barAmount = 0;
				
				if (!__player_can_charge())
					__change_charge_state(0);
				else if (__chargeTimer >= __preChargeDuration)
					__change_charge_state(2);
				break;
			
			case 2: // Charging
				if (__chargeTimer == 0)
					play_sfx(sfxCharging);
				
				var _index = round(remap(0, __chargeDuration, 1, 3, __chargeTimer));
				_index *= (__chargeTimer mod 6 <= 3);
				_index = min(_index, 3);
				
				var _outlineCol = __outlineChargeColours[_index];
				__player.palette.set_output_colour_at(PalettePlayer.outline, _outlineCol);
				if (!is_undefined(__hudElement))
					__hudElement.ammoPalette[PalettePlayer.outline] = _outlineCol;
				
				__barAmount = remap(0, __chargeDuration, 0, 28, __chargeTimer);
				
				if (!__player_can_charge() || (__chargeToggle && __player.inputs.is_pressed(InputActions.SHOOT))) {
					if (!player_is_action_locked(PlayerAction.SHOOT, __player))
						__fire_buster_shot(1);
				} else if (__chargeTimer >= __chargeDuration) {
					__change_charge_state(3);
				}
				break;
			
			case 3: // Fully Charged
				if (__chargeTimer == 0) {
					stop_sfx(sfxCharging);
					play_sfx(sfxCharged);
				}
				
				var _chargeCycle = (__chargeTimer div 3) mod 3;
				for (var i = 0; i < 3; i++) {
					var _chargeCol = __fullChargeColours[modf(_chargeCycle + i, 3)];
					__player.palette.set_output_colour_at(i, _chargeCol);
					if (!is_undefined(__hudElement))
						__hudElement.ammoPalette[i] = _chargeCol;
				}
				
				if (!__player_can_charge() || (__chargeToggle && __player.inputs.is_pressed(InputActions.SHOOT))) {
					if (!player_is_action_locked(PlayerAction.SHOOT, __player))
						__fire_buster_shot(2);
				}
				break;
		}
	};
	
	// - Functions -- Other
	
	__fire_buster_shot = function(_chargeLevel) {
		with (__player) {
			var _moveSpeed = 5,
				_sfx = sfxBuster;
			var _shotData = {
				object: objBusterShot,
				limit: 3,
				cost: 0,
				shootAnimation: 1,
				autoShootDelay: 8
			};
			
			if (_chargeLevel == 1) {
				_shotData.object = objBusterShotHalfCharge;
				_shotData.offsetX = -4;
				_sfx = sfxBusterHalfCharge;
			} else if (_chargeLevel >= 2) {
				_shotData.object = objBusterShotCharged;
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
			
			stop_sfx(sfxCharging);
			stop_sfx(sfxCharged);
			player_refresh_palette();
			isCharging = false;
			other.__change_charge_state(0);
		}
	};
	
	__player_can_charge = function() {
		if (player_is_action_locked(PlayerAction.SHOOT, __player))
			return false;
		
		return options_data().chargeToggle
			? __chargeToggle
			: __player.inputs.is_held(InputActions.SHOOT);
	};
}
