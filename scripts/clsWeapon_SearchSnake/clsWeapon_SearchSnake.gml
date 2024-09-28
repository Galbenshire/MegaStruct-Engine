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
		with (_player) {
			if (!player_shot_input())
				return;
			
			var _shotData = {
				object: objSearchSnake,
				limit: 3,
				cost: 0.5,
				shootAnimation: 1,
				autoShootDelay: 10
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = 1 * image_xscale;
				_shot.yspeed.value = -3 * image_yscale;
				
				play_sfx(sfxBuster);
			}
		}
	};
	
	#endregion
}