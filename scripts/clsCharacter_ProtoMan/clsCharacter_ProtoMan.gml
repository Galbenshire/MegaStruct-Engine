function Character_ProtoMan() : Character() constructor {
	#region Initializing Subfunctions
	
	static __init_spritesheet_lookup_gun_offset = function() {
		var _lookup = array_create(PlayerSpritesheetPage.COUNT);
		
		for (var i = 0; i < PlayerSpritesheetPage.COUNT; i++) {
			switch (i) {
				default:
					// Standing
					_lookup[i][0][0] = [10, 6];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [9, 2];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [10, 6];
					// Climbing
					_lookup[i][1][1] = [12, 4];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [10, 6];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [9, 7];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_UP:
					// Standing
					_lookup[i][0][0] = [8, -4];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [8, 0];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [8, -4];
					// Climbing
					_lookup[i][1][1] = [8, -8];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [9, -5];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [8, -4];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_UP:
					// Standing
					_lookup[i][0][0] = [12, 3];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [12, 2];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [11, 1];
					// Climbing
					_lookup[i][1][1] = [10, -1];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [13, -1];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [11, -2];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_DOWN:
					// Standing
					_lookup[i][0][0] = [10, 11];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [13, 9];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [10, 11];
					// Climbing
					_lookup[i][1][1] = [10, 8];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [11, 11];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [11, 11];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
			}
		}
		
		return _lookup;
	};
	
	#endregion
	
    #region Static Data
	
	static id = CharacterType.PROTO;
	static name = "Proto Man";
	static object = objProtoMan;
	
	static spritesheet = sprPlayerSkinBlues;
	static spritesheetLookupGunOffset = __init_spritesheet_lookup_gun_offset();
	
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