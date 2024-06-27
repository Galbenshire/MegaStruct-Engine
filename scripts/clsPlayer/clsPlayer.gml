/// @func Player(id)
/// @desc Represents the player: the one playing the game
///		  Stores data relevant to them, such as their health, costume, & weapon ammo
///
/// @param {number}  id  Player's ID. Notes which player they are (e.g. 0 = Player 1)
function Player(_id/*:number*/) constructor {
    #region Variables
	
	id = _id; /// @is {number} A reference to the player's ID (i.e. they are Player 1, 2, 3, ...)
	body = noone; /// @is {prtPlayer} A reference to the instance this player is controlling
	inputs = new InputMap();
	canPause = new LockStack(); // Allows the player to pause the game during a level
	
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
		body.player = self;
		body.playerID = id;
		
		return self;
	};
    
    #endregion
}