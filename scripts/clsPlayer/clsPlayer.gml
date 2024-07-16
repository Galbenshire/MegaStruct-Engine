/// @func Player(id)
/// @desc Represents the player: the one playing the game
///		  Stores data relevant to them, such as the player entity they're controlling,
///		  their inputs, and the playable character they have selected
///
/// @param {number}  id  Player's ID. Notes which player they are (e.g. 0 = Player 1)
function Player(_id/*:number*/) constructor {
    #region Variables
	
	id = _id; /// @is {number} A reference to the player's ID (i.e. they are Player 1, 2, 3, ...)
	character = CharacterType.MEGA; // Which playable character this player is set to be
	body = noone; /// @is {prtPlayer} A reference to the instance this player is controlling
	inputs = new InputMap();
	lockpool = new PlayerLockPool();
	hudElement = new PlayerHUD();
	
	#endregion
	
	#region Functions - Getters
	
	/// -- get_character()
	/// Gets the player's currently selected character
	///
	/// @returns {Character}  The current character
	static get_character = function() {
		return global.characterList[character];
	};
	
	#endregion

    #region Functions - Setters
    
    /// @method set_body(body)
	/// @desc Sets the instance representing the player's body
	///
	/// @param {prtPlayer}  body  The instance to use as a body
	///
	/// @returns {Player}  A reference to this struct. Useful for method chaining.
	static set_body = function(_body/*:prtPlayer*/) {
		assert(is_a_player(_body), "only objects that inherit from prtPlayer can be used as the player's body");
		
		body = _body;
		body.playerUser = self;
		body.playerID = id;
		
		return self;
	};
	
	/// @method set_body_healthpoints(value)
	/// @desc Sets the healthpoints on the player entity this user is controlling
	///
	/// @param {number}  value  The new health value
	///
	/// @returns {Player}  A reference to this struct. Useful for method chaining.
	static set_body_healthpoints = function(_value) {
		if (instance_exists(body))
			body.healthpoints = clamp(_value, 0, body.healthpointsStart);
		return self;
	};
    
    #endregion
    
    #region Functions - Other
    
    /// @method change_body_healthpoints(value)
	/// @desc Changes the healthpoints of the player's body by a specific amount
	///
	/// @param {number}  value  How much to change health by
	///
	/// @returns {Player}  A reference to this struct. Useful for method chaining.
	static change_body_healthpoints = function(_value) {
		if (instance_exists(body))
			body.healthpoints = clamp(body.healthpoints + _value, 0, body.healthpointsStart);
		return self;
	};
    
    /// @method generate_loadout()
	/// @desc Generates a weapon loadout for the player's body
	///		  This will be based on the player's currently selected character
    static generate_loadout = function() {
		if (!instance_exists(body))
			return;
		
		var _loadout = get_character().loadout,
			_loadoutSize = array_length(_loadout);
		for (var i = 0; i < _loadoutSize; i++)
			player_add_weapon(_loadout[i], body);
    }
    
    #endregion
}