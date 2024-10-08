function Weapon_IceSlasher() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.ICE_SLASHER;
	static colours = [ $F85800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 4;
	
	// - Name
	static name = "Ice Slasher";
	static shortName = "I.Slasher";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot())
			return;
		
		var _shot = _player.fire_weapon({
			object: objIceSlasher,
			limit: 2,
			cost: 1,
			shootAnimation: 1,
			autoShootDelay: 14
		});
		
		if (_shot != noone) {
			_shot.xspeed.value = 5 * _player.image_xscale;
			play_sfx(sfxIceSlasher);
		}
	};
	
	#endregion
}