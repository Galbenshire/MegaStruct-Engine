function Character_MegaMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.MEGA;
	
	#endregion
	
	#region Variables
	
	name = "Mega Man";
	entityObject = objMegaMan;
	
	playerColours[PalettePlayer.primary] = $EC7000;
	playerColours[PalettePlayer.secondary] = $F8B838;
	playerColours[PalettePlayer.outline] = $000000;
	playerColours[PalettePlayer.skin] = $A8D8FC;
	playerColours[PalettePlayer.face] = $000000;
	playerColours[PalettePlayer.eyes] = $FFFFFF;
	
	coilColours[PalettePlayer.primary] = $0028D8;
	coilColours[PalettePlayer.secondary] = $F8F8F8;
	coilColours[PalettePlayer.outline] = $000000;
	coilColours[PalettePlayer.skin] = $A8D8FC;
	coilColours[PalettePlayer.face] = $000000;
	coilColours[PalettePlayer.eyes] = $FFFFFF;
	jetColours = coilColours;
    
	weapons = [
        WeaponType.BUSTER,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER,
        WeaponType.RUSH_COIL,
        WeaponType.RUSH_JET
    ];
	
	#endregion
	
	#region Functions
	
	static personalize_weapon = function(_weapon) {
		switch (_weapon.id) {
			case WeaponType.BUSTER:
				//_weapon.set_colours([ $F87800, $D8E800 ]); // NES
				_weapon.set_colours([ $EC7000, $F8B838 ]); // MM9-10
				break;
		}
	};
	
	#endregion
}