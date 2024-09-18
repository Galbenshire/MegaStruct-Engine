function Character_MegaMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.MEGA;
	static name = "Mega Man";
	static object = objMegaMan;
	
	static colours = [
        $EC7000,
        $F8B838,
        $000000,
        $A8D8FC,
        $000000,
        $FFFFFF
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