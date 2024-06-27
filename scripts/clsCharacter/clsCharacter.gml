/// @func Character(config)
/// @desc Represents a character that the player can play as in this engine
///
/// @param {struct}  config  A struct to configure this character
function Character(_config = {}) constructor {
    #region Variables
	
	id = _config.id; /// @is {int} A reference to the character's ID corresponding to the CharacterType enum
	
	name = _config.name; /// @is {string} Character's name
	object = _config.object; /// @is {prtPlayer} The object representing this character. When the player spawns into a level, this object will be created for them to control.
	colours = _config.colours; /// @is {PlayerPalette}
	loadout = _config.loadout; /// @is {array<int>} A list of weapons this character will have available to them
	
	#endregion
	
	#region Functions - Getters
	
	/// -- get_colours()
	/// Gets the colours of this character. It would be used as a base, changed by the player's current weapon.
	///
	/// @returns {PlayerPalette}  A copy of this characters's colours.
	static get_colours = function() {
		return variable_clone(colours);	
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
