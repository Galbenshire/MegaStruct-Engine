function Weapon_SearchSnake() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.SEARCH_SNAKE;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 5;
	iconColours = [ $00B800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Search Snake";
	shortName = "S.Snake";
	
	// - Shot Data
	shotData.set_shot_object(objSearchSnake)
		.set_shot_limit(3, [ objSearchSnake ])
		.set_ammo_cost(0.5, false)
		.set_shoot_animation(PlayerShootType.SHOOT)
		.set_auto_shoot_delay(10);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot())
			return;
		
		var _shot = _player.fire_weapon(shotData);
		if (_shot != noone) {
			_shot.depth = _player.depth + 5;
			_shot.xspeed = 1 * _player.image_xscale;
			_shot.yspeed = -3 * _player.image_yscale;
			play_sfx(sfxBuster);
		}
	};
	
	#endregion
}