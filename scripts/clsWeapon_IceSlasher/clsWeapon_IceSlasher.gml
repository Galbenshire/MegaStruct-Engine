function Weapon_IceSlasher() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.ICE_SLASHER;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 4;
	iconColours = [ $F85800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Ice Slasher";
	shortName = "I.Slasher";
	
	// - Shot Data
	shotData.set_shot_object(objIceSlasher)
		.set_shot_limit(2, [ objIceSlasher ])
		.set_ammo_cost(1, false)
		.set_shoot_animation(PlayerShootType.SHOOT)
		.set_auto_shoot_delay(14);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot())
			return;
		
		var _shot = _player.fire_weapon(shotData);
		if (_shot != noone) {
			_shot.xspeed = 5 * _player.image_xscale;
			play_sfx(sfxIceSlasher);
		}
	};
	
	#endregion
}