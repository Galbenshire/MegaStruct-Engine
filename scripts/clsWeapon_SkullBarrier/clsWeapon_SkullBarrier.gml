function Weapon_SkullBarrier() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.SKULL_BARRIER;
	
	#endregion
	
	#region Variables
	
	colours = [ $FCBC3C, $F0FC9C, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 6;
	
	// - Name
	name = "Skull Barrier";
	shortName = "S.Barrier";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot(false))
			return;
		
		var _shot = _player.fire_weapon({
			object: objSkullBarrier,
			limit: 1,
			cost: 2,
			shootAnimation: PlayerSpritesheetPage.IDLE,
		});
		
		with (_shot) {
            x = sprite_x_center(_player);
            y = sprite_y_center(_player);
            image_xscale = 1;
            image_yscale = 1;
			play_sfx(sfxBuster);
		}
	};
	
	#endregion
}