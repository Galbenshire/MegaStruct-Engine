function Weapon_MetalBlade() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.METAL_BLADE;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 3;
	iconColours = [ $007088, $A8E0FF, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Metal Blade";
	shortName = "M.Blade";
	
	// - Shot Data
	shotData.set_shot_object(objMetalBlade)
		.set_shot_limit(3, [ objMetalBlade ])
		.set_ammo_cost(0.5, false)
		.set_shoot_animation(PlayerShootType.THROW)
		.set_shoot_standstill(true)
		.set_spawn_offset(0, 3)
		.set_auto_shoot_delay(20);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
            if (!self.check_input_shoot())
				return;
			
			var _shot = self.fire_weapon(other.shotData);
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