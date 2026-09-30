// These are base callbacks for `onFrame`
// `onFrame` is called every game frame, before any game ticks (if any) are processed.
//
// By default, most entities will have no need for this function.
// Players, on the other hand, will use this callback to grab inputs from the user,
// regardless of whether or not a game tick will occur.
//
// NOTE: Unlike a "game tick", a frame is an actual in-game frame.
//       This means a frame always occurs once.

#region Base Callback

/// @func cbkOnFrame_base()
/// @desc Default onFrame callback for all entities
function cbkOnFrame_base() {
    //...
}

#endregion

#region Available Presets

/// @func cbkOnFrame_player()
/// @desc onFrame callback for players
function cbkOnFrame_player() {
    self.handle_input();
}

#endregion