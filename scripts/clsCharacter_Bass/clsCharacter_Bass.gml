function Character_Bass() : Character() constructor {
	#region Static Data
	
	static id = CharacterType.BASS;
	
	#endregion
	
	#region Variables
	
	name = "Bass";
	entityObject = objBass;
	spritesheet = sprPlayerSkinForte;
	spritesheetLookupGunOffset = __init_spritesheet_lookup_gun_offset();
	
	defaultColours = [
		// Main Colours
        $707070,
        $3898F8,
        $000000,
        
        // Less Important Colours
        $A8E0F8,
        $000000,
        $FFFFFF,
        
        // Pretty Much Mugshot Exclusive
        $F80080,
        $5800E0,
        $3898F8
    ];
    
	weapons = [
        WeaponType.BUSTER_BASS,
        WeaponType.ICE_SLASHER,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER
    ];
	
	#endregion
	
	#region Initializing Subfunctions
	
	// I didn't think I'd need to do this explicitly for Bass,
	// since his sprites are just Mega Man's with extra detail slapped on.
	// Then I remembered he dashes, rather than slides
	static __init_spritesheet_lookup_gun_offset = function() {
		var _parent = static_get(static_get(self)),
			_lookup = _parent.__init_spritesheet_lookup_gun_offset();
		
		for (var i = 0; i < PlayerSpritesheetPage.COUNT; i++) {
			switch (i) {
				default:
					_lookup[i][0][2] = [18, 8];
					_lookup[i][0][3] = _lookup[i][0][2];
					break;
				
				case PlayerSpritesheetPage.SHOOT_UP:
					_lookup[i][0][2] = [15, -1];
					_lookup[i][0][3] = _lookup[i][0][2];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_UP:
					_lookup[i][0][2] = [18, 0];
					_lookup[i][0][3] = _lookup[i][0][2];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_DOWN:
					_lookup[i][0][2] = [15, 14];
					_lookup[i][0][3] = _lookup[i][0][2];
					break;
			}
		}
		
		return _lookup;
	};
	
	#endregion
}