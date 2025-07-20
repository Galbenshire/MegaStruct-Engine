function Weapon_SearchSnake() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.SEARCH_SNAKE;
	
	#endregion
	
	#region Variables
	
	colours = [ $00B800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 5;
	
	// - Name
	name = "Search Snake";
	shortName = "S.Snake";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot())
			return;
		
		var _shot = _player.fire_weapon({
			object: objSearchSnake,
			limit: 3,
			cost: 0.5,
			shootAnimation: PlayerSpritesheetPage.SHOOT,
			autoShootDelay: 10
		});
		
		if (_shot != noone) {
			_shot.xspeed.value = 1 * _player.image_xscale;
			_shot.yspeed.value = -3 * _player.image_yscale;
			play_sfx(sfxBuster);
		}
	};
	
	#endregion
}