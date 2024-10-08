function Character_MegaMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.MEGA;
	static name = "Mega Man";
	static object = objMegaMan;
	static spritesheet = sprPlayerSkinRockMan;
	
	static defaultColours = [
		// Main Colours
        $EC7000,
        $F8B838,
        $000000,
        
        // Less Important Colours
        $A8D8FC,
        $000000,
        $FFFFFF,
        
        // Pretty Much Mugshot Exclusive
        $8B0000,
        $FFEEB3,
        $3898F8
    ];
    
	static loadout = [
        WeaponType.BUSTER,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER
    ];
	
	#endregion
}