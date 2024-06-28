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

/// @func cbkOnDraw_prtPlayer(whiteflash)
/// @desc Default onDraw callback for players.
///       prtPlayer calls onDraw a it differently from regular entities;
///       the `whiteflash` variable is not used here
///
/// @param {bool}  whiteflash  Unused here
function cbkOnDraw_prtPlayer(_whiteflash) {
	if (iFrames < 0 || (iFrames & 3) < 2) {
		if (isHurt && (stateMachine.timer & 7) <= 3) {
			draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), image_xscale, image_yscale, 0, c_white, 1);
		} else {
			bodyPalette.activate();
            global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, 0, x, y, image_xscale, image_yscale, c_white, 1);
            bodyPalette.deactivate();
		}
	}
}

/// @func cbkOnDraw_colourReplacer(whiteflash)
/// @desc onDraw callback preset for when an entity uses a ColourReplacer palette
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_colourReplacer(_whiteflash) {
    if (_whiteflash || is_undefined(palette)) {
        draw_self();
    } else {
        palette.activate();
        draw_self();
        palette.deactivate();
    }
}
