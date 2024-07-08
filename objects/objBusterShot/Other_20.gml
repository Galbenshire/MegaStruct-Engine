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
		var _inputs = _player.inputs,
			_shootLocked = player_is_action_locked(PlayerAction.SHOOT, _player),
			_chargeLocked = player_is_action_locked(PlayerAction.CHARGE, _player),
			_prevChargeState = __chargeState;
		
		switch (__chargeState) {
			case 0: // no charge
				if (_inputs.is_pressed(InputActions.SHOOT) && !_shootLocked) {
					__fireBusterShot(_player, 0);
				} else if (!_player.isShooting && _inputs.is_held(InputActions.SHOOT) && !_chargeLocked) {
					__chargeState = 1;
				}
				break;
			
			case 1: // precharge
				if (!_inputs.is_held(InputActions.SHOOT) || _chargeLocked) {
					__chargeState = 0;
					return;
				}
				
				if (__chargeTimer++ >= __preChargeDuration) {
					__chargeState = 2;
					_player.isCharging = true;
					play_sfx(sfxCharging);
				}
				break;
			
			case 2: // charging
				var _index = round(remap(0, __chargeDuration, 1, 3, __chargeTimer));
				_index *= (__chargeTimer mod 6 <= 3);
				_index = min(_index, 3);
				_player.palette.set_output_colour_at(PalettePlayer.outline, __outlineChargeColours[_index]);
				
				if (!is_undefined(_player.player)) {
					_player.player.hudElement.ammoPalette[PalettePlayer.outline] = __outlineChargeColours[_index];
					_player.player.hudElement.ammo = remap(0, __chargeDuration, 0, 28, __chargeTimer);
				}
				
				__chargeTimer++;
				
				if (!_inputs.is_held(InputActions.SHOOT) || _chargeLocked) {
					if (!_shootLocked)
						__fireBusterShot(_player, 1);
				} else if (__chargeTimer >= __chargeDuration) {
					__chargeState = 3;
					stop_sfx(sfxCharging);
                    play_sfx(sfxCharged);
				}
				break;
			
			case 3: // fully charged
				__chargeTimer++;
				
				var _chargeCycle = (__chargeTimer div 3) mod 3;
				for (var i = 0; i < 3; i++) {
					_player.palette.set_output_colour_at(i, __fullChargeColours[modf(_chargeCycle + i, 3)]);
					if (!is_undefined(_player.player))
						_player.player.hudElement.ammoPalette[PalettePlayer.outline] = __fullChargeColours[modf(_chargeCycle + i, 3)];
				}
				
				if (!_inputs.is_held(InputActions.SHOOT) || _chargeLocked) {
					if (!_shootLocked)
						__fireBusterShot(_player, 2);
				}
				break;
		}
		
		if (__chargeState != _prevChargeState)
			__chargeTimer = 0;
		_player.isCharging = (__chargeState >= 2);
	};
	
	onEquip = function(_player) {
		__chargeTimer = 0;
		__chargeState = 0;
		with (_player) {
			isCharging = false;
			if (!is_undefined(player)) {
				player.hudElement.ammoVisible = true;
				player.hudElement.ammo = 0;
			}
		}
	};
	
	onUnequip = function(_player) {
		stop_sfx(sfxCharging);
		stop_sfx(sfxCharged);
		_player.isCharging = false;
	};
	
	// == Weapon Specific ==
	
	__preChargeDuration = 20;
	__chargeDuration = 57;
	__outlineChargeColours = [ $000000, $2000A8, $5800E4, $9858F8 ];
	__fullChargeColours = [ colours[PaletteWeapon.primary], colours[PaletteWeapon.secondary], $000000 ];
	
	__chargeTimer = 0;
	__chargeState = 0; // 0 - not charging; 1 - pre charging; 2 - charging; 3 - fully charged;
	
	__fireBusterShot = function(_player, _chargeLevel) {
		with (_player) {
			var _moveSpeed = 5,
				_sfx = sfxBuster;
			var _shotData = {
				object: objBusterShot,
				limit: 3,
				cost: 0,
				shootAnimation: 1
			};
			
			if (_chargeLevel >= 2) {
				_shotData.object = objBusterShotCharged;
				_shotData.offsetX = 4;
				_moveSpeed = 5.5;
				_sfx = sfxBusterCharged;
			} else if (_chargeLevel == 1) {
				_shotData.object = objBusterShotHalfCharge;
				_shotData.offsetX = -4;
				_sfx = sfxBusterHalfCharge;
			}
			
			var _shot = player_fire_weapon(_shotData, _player);
			if (_shot != noone) {
				_shot.xspeed.value = _moveSpeed * image_xscale;
				play_sfx(_sfx);
			}
			
			stop_sfx(sfxCharging);
			stop_sfx(sfxCharged);
			player_refresh_palette(_player);
			other.__chargeState = 0;
			other.__chargeTimer = 0;
			isCharging = false;
		}
	};
}
