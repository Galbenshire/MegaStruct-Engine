function Weapon_SearchSnake() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.SEARCH_SNAKE;
	static colours = [ $00B800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 5;
	
	// - Name
	static name = "Search Snake";
	static shortName = "S.Snake";
	
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