function Character_ProtoMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.PROTO;
	static name = "Proto Man";
	static object = objProtoMan;
	
	static defaultColours = [
		// Main Colours
        $0028DC,
        $BCBCBC,
        $000000,
        
        // Less Important Colours
        $A5E7FF,
        $000000,
        $FFFFFF,
        
        // Pretty Much Mugshot Exclusive
        $1000A8,
        $F8F8F8,
        $3898F8
    ];
    
	static loadout = [
        WeaponType.BUSTER_PROTO,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE
    ];
	
	#endregion
}