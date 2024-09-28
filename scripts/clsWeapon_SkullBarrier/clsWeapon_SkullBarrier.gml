function Weapon_SkullBarrier() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.SKULL_BARRIER;
	static colours = [ $FCBC3C, $F0FC9C, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 6;
	
	// - Name
	static name = "Skull Barrier";
	static shortName = "S.Barrier";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
			if (!player_shot_input(false))
				return;
			
			var _shotData = {
				object: objSkullBarrier,
				limit: 1,
				cost: 2,
				shootAnimation: 0
			};
			
			var _shot = player_fire_weapon(_shotData);
			with (_shot) {
                x = sprite_x_center(other);
                y = sprite_y_center(other);
                image_xscale = 1;
                image_yscale = 1;
				play_sfx(sfxBuster);
			}
		}
	};
	
	#endregion
}