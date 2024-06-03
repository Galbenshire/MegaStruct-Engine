/// @func Player(id)
/// @desc Represents the player: the one playing the game
///		  Stores data relevant to them, such as their health, costume, & weapon ammo
///
/// @param {number}  id  Player's ID. Notes which player they are (e.g. 0 = Player 1)
function Player(_id/*:number*/) constructor {
    #region Variables
	
	id = _id; /// @is {number} A reference to the player's ID (i.e. they are Player 1, 2, 3, ...)
	healthpoints = FULL_HEALTHBAR; /// @is {number} The player's health. If it reaches 0, they die, & the room restarts.
	inputs = new InputMap(); /// @is {InputMap}
	
	#endregion

    
}