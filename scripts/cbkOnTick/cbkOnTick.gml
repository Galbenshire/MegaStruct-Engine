// These are base callbacks for `onTick`
// `onTick` is called every game tick, BEFORE the entity moves.
// This is where the majority of an entity's logic will be executed.
//
// By default, this callback will run the User Event reserved for Ticks (User Event 14).
// This means that if you want to define how an entity should move every step,
// overriding their object's User Event 14 is recommended over defining a new callback.
//
// However, the option to override the callback is still present, should the need arise.
//
// NOTE: A "game tick" is dependant on the current game speed.
//       This means a tick may not occur on a given frame, or may occur multiple times.
//
// == Parameters
// tick (int) - Which "tick" of the current frame this is (only ever goes above 0 if game speed is higher than 1)
//

/// @func cbkOnTick_base(tick)
/// @desc Default onTick callback for all entities
///
/// @param {int}  tick  Current Tick
function cbkOnTick_base(_tick) {
    event_user(EVENT_ENTITY_TICK);
}
