function Weapon_SkullBarrier() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.SKULL_BARRIER;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 6;
	iconColours = [ $FCBC3C, $F0FC9C, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Skull Barrier";
	shortName = "S.Barrier";
	
	// - Shot Data
	shotData.set_shot_object(objSkullBarrier)
		.set_shot_limit(1, [ objSkullBarrier ])
		.set_ammo_cost(2, false)
		.set_shoot_animation(undefined)
		.set_spawn_offset(0, 0, false);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot(false))
			return;
		
		var _shot = _player.fire_weapon(shotData);
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