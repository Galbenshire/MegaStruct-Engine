function Weapon_RushJet() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.RUSH_JET;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 8;
	iconColours = [ $0028D8, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Rush Jet";
	shortName = "R.Jet";
	
	// - Shot Data
	shotData.set_shot_object(objRushJet)
		.set_shot_limit(1, [ objRushJet ])
		.set_shoot_animation(undefined)
		.set_spawn_offset(37, 0, false)
		.set_shot_param("characterSpecs", undefined);
		
	// == Dog-Specific Variables ==
	
	shotDataBuster = create_weapon_shot_builder()
		.set_shot_object(objBusterShot)
		.set_shot_limit(3, [ objBusterShot ])
		.set_shoot_animation(PlayerShootType.SHOOT)
		.set_auto_shoot_delay(8);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (shotData.check_shot_limit(_player) && ammo > 0) {
			if (!_player.check_input_shoot(false))
				return;
			
			shotData.set_shot_param("characterSpecs", _player.characterSpecs);
			
			var _shot = _player.fire_weapon(shotData);
			if (_shot != noone) {
				_shot.weapon = self;
				_shot.depth = _player.depth - 1;
			}
		} else {
			if (!_player.check_input_shoot())
				return;
			
			var _shot = _player.fire_weapon(shotDataBuster);
			if (_shot != noone) {
				_shot.xspeed = 5 * _player.image_xscale;
				play_sfx(sfxBuster);
			}
		}
	};
	
	#endregion
}
