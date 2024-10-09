/// @func Character()
/// @desc Represents a character that the player can play as in this engine
function Character() constructor {
	#region Initializing Subfunctions
	
	/// -- __init_spritesheet_lookup_gun_offset()
	/// Sets up the lookup table for the spritesheet gun offsets
	/// This contains the relative position of the character's "gun" on each cell of each page
	/// The lookup table is a 4-dimensional array in the following format:
	///	[PAGE][CELL_ROW][CELL_COLUMN][VECTOR_AXIS]
	///
	/// @returns {array<array<array<Vector2>>>}
	static __init_spritesheet_lookup_gun_offset = function() {
		var _lookup = array_create(PlayerSpritesheetPage.COUNT);
		
		for (var i = 0; i < PlayerSpritesheetPage.COUNT; i++) {
			switch (i) {
				default:
					// Standing
					_lookup[i][0][0] = [17, 4];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [9, 2];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [17, 4];
					// Climbing
					_lookup[i][1][1] = [13, 2];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [17, 4];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [13, 3];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_UP:
					// Standing
					_lookup[i][0][0] = [5, -5];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [7, 0];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [5, -5];
					// Climbing
					_lookup[i][1][1] = [5, -7];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [10, -3];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [6, -5];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_UP:
					// Standing
					_lookup[i][0][0] = [15, -2];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [11, 1];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [15, -2];
					// Climbing
					_lookup[i][1][1] = [12, -4];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [13, -1];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [12, -2];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
				
				case PlayerSpritesheetPage.SHOOT_DIAGONAL_DOWN:
					// Standing
					_lookup[i][0][0] = [14, 10];
					_lookup[i][0][1] = _lookup[i][0][0];
					// Sliding
					_lookup[i][0][2] = [11, 10];
					_lookup[i][0][3] = _lookup[i][0][2];
					// Sidestep
					_lookup[i][1][0] = [14, 10];
					// Climbing
					_lookup[i][1][1] = [11, 9];
					_lookup[i][1][2] = _lookup[i][1][1];
					_lookup[i][1][3] = _lookup[i][1][1];
					// Walking
					_lookup[i][2][0] = [11, 13];
					_lookup[i][2][1] = _lookup[i][2][0];
					_lookup[i][2][2] = _lookup[i][2][0];
					_lookup[i][2][3] = _lookup[i][2][0];
					// Jumping
					_lookup[i][3][0] = [12, 10];
					_lookup[i][3][1] = _lookup[i][3][0];
					_lookup[i][3][2] = _lookup[i][3][0];
					_lookup[i][3][3] = _lookup[i][3][0];
					break;
			}
		}
		
		return _lookup;
	};
	
	/// -- __init_spritesheet_lookup_page()
	/// Sets up the lookup table for the spritesheet pages
	///
	/// @returns {array<int>}
	static __init_spritesheet_lookup_page = function() {
		var _lookup = array_create(PlayerSpritesheetPage.COUNT);
		_lookup[PlayerSpritesheetPage.IDLE] = 0;
		_lookup[PlayerSpritesheetPage.SHOOT] = 1;
		_lookup[PlayerSpritesheetPage.THROW] = 2;
		_lookup[PlayerSpritesheetPage.SHOOT_UP] = 3;
		_lookup[PlayerSpritesheetPage.SHOOT_DIAGONAL_UP] = 4;
		_lookup[PlayerSpritesheetPage.SHOOT_DIAGONAL_DOWN] = 5;
		_lookup[PlayerSpritesheetPage.SUPER_ARM] = 6;
		_lookup[PlayerSpritesheetPage.WIRE_ADAPTOR] = 7;
		_lookup[PlayerSpritesheetPage.SLASH_CLAW] = 8;
		_lookup[PlayerSpritesheetPage.TENGU_BLADE] = 9;
		_lookup[PlayerSpritesheetPage.BREAK_DASH] = 10;
		_lookup[PlayerSpritesheetPage.TORNADO_BATTERY] = 10;
		_lookup[PlayerSpritesheetPage.SAKUGARNE] = 11;
		_lookup[PlayerSpritesheetPage.BIKE] = 11;
		_lookup[PlayerSpritesheetPage.TURNABOUT] = 12;
		_lookup[PlayerSpritesheetPage.TOP_SPIN] = 12;
		_lookup[PlayerSpritesheetPage.HURT] = 13;
		_lookup[PlayerSpritesheetPage.STUN] = 13;
		_lookup[PlayerSpritesheetPage.LIFE] = 13;
		_lookup[PlayerSpritesheetPage.MUGSHOT] = 13;
		_lookup[PlayerSpritesheetPage.COIL] = 13;
		_lookup[PlayerSpritesheetPage.JET] = 13;
		_lookup[PlayerSpritesheetPage.WAVE_BIKE] = 13;
		_lookup[PlayerSpritesheetPage.TELEPORT] = 13;
		return _lookup;
	};
	
	#endregion
	
	#region Static Data (consistent across all character instances)
	
	// ID corresponding to the CharacterType enum
	static id = -1;
	
	// Name of this character
	static name = "";
	
	// The object representing this character. When the player spawns into a level, this object will be created for them to control.
	static object = prtPlayer;
	
	// Spritesheet that's used as the "skin" for the character entity
	static spritesheet = sprPlayerSkinRockMan;
	
	// An array for storing which image_index of the spritesheet corresponds to which "page"
	static spritesheetLookupPage = __init_spritesheet_lookup_page();
	
	// An array for storing the relativve position of the player's "gun" on each spritesheet cell & page
	static spritesheetLookupGunOffset = __init_spritesheet_lookup_gun_offset();
	
	// Default colour palette for this character
	static defaultColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer}
	
	// A list of weapons this character will have available to them
	static loadout = []; /// @is {array<int>}
	
	#endregion
	
	#region Functions
	
	/// -- get_default_colours()
	/// Gets the default colours of this character. This is without any changes by weapons.
	///
	/// @returns {PalettePlayer}  A copy of this characters's colours.
	static get_default_colours = function() {
		return variable_clone(defaultColours);
	};
	
	/// -- get_loadout()
	/// Gets this character associated loadout. Playing as this character gives you these weapons.
	///
	/// @returns {array<int>}  A copy of this characters's loadout.
	static get_loadout = function() {
		return variable_clone(loadout);
	};
	
	/// -- get_name(uppercase)
	/// Gets the name of this character.
	/// Can choose to have the name converted into uppercase.
	///
	/// @param {bool}  [uppercase]  Whether to return the name in uppercase or not. Defaults to false.
	///
	/// @returns {array<int>}  A copy of this characters's loadout.
	static get_name = function(_upper = false) {
		return _upper ? string_upper(name) : name;
	};
	
	/// -- spritesheet_gun_offset(page, cell_x, cell_y)
	/// Gets the gun offset at the given page & cell of the spritesheet
	///
	/// @param {int}  page  The spritesheet page
	/// @param {int}  cell_x  horizontal position of the cell on the given page
	/// @param {int}  cell_y  vertical position of the cell on the given page
	///
	/// @returns {Vector2}  The gun offset
	static spritesheet_gun_offset = function(_page, _cellX, _cellY) {
		_page = in_range(_page, 0, PlayerSpritesheetPage.COUNT) ? _page : 0;
		_cellX = clamp(_cellX, 0, 3);
		_cellY = clamp(_cellY, 0, 3);
		return spritesheetLookupGunOffset[_page][_cellY][_cellX];
	};
	
	/// -- spritesheet_page_to_image_index(page)
	/// Converts the given spritesheet page to its corresponding image_index
	///
	/// @param {int}  page  The spritesheet page to convert
	///
	/// @returns {int}  The image_index tied to this page
	static spritesheet_page_to_image_index = function(_page) {
		return array_at(spritesheetLookupPage, max(_page, 0)) ?? 0;
	}
	
	#endregion
}

/// @func character_create_from_id(id)
/// @desc Generates an instance of a playable character (i.e. a struct with info about that character)
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {Character}  A character instance
function character_create_from_id(_id) {
	switch (_id) {
		case CharacterType.MEGA: return new Character_MegaMan(); break;
		case CharacterType.PROTO: return new Character_ProtoMan(); break;
		case CharacterType.BASS: return new Character_Bass(); break;
	}
	
	return undefined;
}

/// @func character_object_from_id(id)
/// @desc Gets the player object that represents the given character
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {prtPlayer}  Object of the character
function character_object_from_id(_id) {
	var _temp = character_create_from_id(_id),
		_obj = _temp.object;
	delete _temp;
	return _obj;
}
