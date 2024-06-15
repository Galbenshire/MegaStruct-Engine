// These are base callbacks for `onDraw`
// As the name suggests, `onDraw` will be called when it's time to draw an entity.
//
// By default, this will occur in the Draw Event, and the following will already be accounted for:
// - If the entity can even be drawn this frame  (e.g. they might be dead)
// - Whether or not they're in a subpixel position
// - Whether or not they're experiencing white-flashing fom i-frames
//
// == Parameters
// whiteflash (bool) - Determines if the entity has a white-flash effect (true) or not (false)
//      This would be important for if you're using shaders to draw
//

/// @func cbkOnDraw_prtEntity(whiteflash)
/// @desc Default onDraw callback for all entities
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_prtEntity(_whiteflash) {
    draw_self();
}
