function Character_Bass() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.BASS;
	static name = "Bass";
	static object = objBass;
	static spritesheet = sprPlayerSkinForte;
	
	static colours = [
        $707070,
        $3898F8,
        $000000,
        $A5E7FF,
        $000000,
        $FFFFFF
    ];
    
	static loadout = [
        WeaponType.BUSTER_BASS,
        WeaponType.ICE_SLASHER,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER
    ];
	
	#endregion
}