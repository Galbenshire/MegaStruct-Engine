function Weapon_IceSlasher() : Weapon() constructor {
    #region Static Data
	
	static id = WeaponType.ICE_SLASHER;
	
	#endregion
	
	#region Variables
	
	colours = [ $F85800, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 4;
	
	// - Name
	name = "Ice Slasher";
	shortName = "I.Slasher";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (!_player.check_input_shoot())
			return;
		
		var _shot = _player.fire_weapon({
			object: objIceSlasher,
			limit: 2,
			cost: 1,
			shootAnimation: PlayerStandardAnimationSubType.SHOOT,
			autoShootDelay: 14
		});
		
		if (_shot != noone) {
			_shot.xspeed.value = 5 * _player.image_xscale;
			play_sfx(sfxIceSlasher);
		}
	};
	
	#endregion
}