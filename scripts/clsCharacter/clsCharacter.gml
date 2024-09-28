/// @func Character()
/// @desc Represents a character that the player can play as in this engine
function Character() constructor {
	#region Static Data (consistent across all weapon instances)
	
	static id = -1;
	static name = "";
	static object = prtPlayer; // The object representing this character. When the player spawns into a level, this object will be created for them to control.
	static defaultColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer}
	static loadout = []; /// @is {array<int>} A list of weapons this character will have available to them
	
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
	
	#endregion
}

/// @func character_create_from_id(id)
/// @desc Generates an instance of a playable character
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
