// These are base callbacks for `onPostTick`
// `onPostTick` is called every game tick, AFTER the entity moves.
// This is where an entity can perform actions based on how they moved.
//
// By default, this callback will run the User Event reserved for Post Ticks (User Event 15).
// This means that if you want to define how an entity should move every step after movement,
// overriding their object's User Event 15 is recommended over defining a new callback.
//
// However, the option to override the callback is still present, should the need arise.
//
// NOTE: A "game tick" is dependant on the current game speed.
//       This means a tick may not occur on a given frame, or may occur multiple times.
//
// == Parameters
// tick (int) - Which "tick" of the current frame this is (only ever goes above 0 if game speed is higher than 1)
//

#region Base Callback

/// @func cbkOnPostTick_base()
/// @desc Default onPostTick callback for all entities
///
/// @param {int}  tick  Current Tick
function cbkOnPostTick_base(_tick) {
    event_user(EVENT_ENTITY_POSTTICK);
}

#endregion

#region Available Presets

/// @func cbkOnPostTick_player()
/// @desc onPostTick callback for players
///
/// @param {int}  tick  Current Tick
function cbkOnPostTick_player(_tick) {
    event_user(EVENT_ENTITY_POSTTICK);
    signal_bus().emit_signal(SIGNAL_PLAYER_INPUT, {
        player: self.id,
        inputs: inputs
    });
    inputs.clear_momentary();
}

#endregion
