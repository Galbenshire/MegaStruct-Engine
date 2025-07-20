function Weapon_MetalBlade() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.METAL_BLADE;
	
	#endregion
	
	#region Variables
	
	colours = [ $007088, $A8E0FF, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 3;
	
	// - Name
	name = "Metal Blade";
	shortName = "M.Blade";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
            if (!self.check_input_shoot())
				return;
			
			var _shot = self.fire_weapon({
				object: objMetalBlade,
				limit: 3,
				cost: 0.5,
				shootAnimation: PlayerSpritesheetPage.THROW,
				offsetY: 3,
				standstill: true,
				autoShootDelay: 20
			});
			
			if (_shot != noone) {
				var _dir = 180 * (image_xscale < 0);
                
                if (yDir != 0) {
                    _dir -= (yDir * 90) * image_xscale;
                    if (xDir != 0)
                        _dir += (yDir * 45) * image_xscale;
                }
                
                set_velocity_vector(4, _dir, _shot);
				play_sfx(sfxMetalBlade);
			}
        }
	};
	
	#endregion
}