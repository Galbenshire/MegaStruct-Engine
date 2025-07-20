function Character_MegaMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.MEGA;
	
	#endregion
	
	#region Variables
	
	name = "Mega Man";
	entityObject = objMegaMan;
	spritesheet = sprPlayerSkinRockMan;
	
	defaultColours = [
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