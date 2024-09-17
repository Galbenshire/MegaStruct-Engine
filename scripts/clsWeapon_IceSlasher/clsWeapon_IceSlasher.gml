function Weapon_IceSlasher() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.ICE_SLASHER;
	static colours = [ $F85800, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 4;
	
	// - Name
	static name = "Ice Slasher";
	static shortName = "I.Slasher";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
			if (!player_shot_input())
				return;
			
			var _shotData = {
				object: objIceSlasher,
				limit: 2,
				cost: 1,
				shootAnimation: 1,
				autoShootDelay: 14
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = 5 * image_xscale;
				play_sfx(sfxIceSlasher);
			}
		}
	};
	
	#endregion
}