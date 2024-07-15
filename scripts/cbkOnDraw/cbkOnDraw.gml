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
	if (palette.isSupported) {
		palette.activate();
        global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, 0, x, y, image_xscale, image_yscale, image_blend, image_alpha);
        palette.deactivate();
        return;
	}
	
	// Shaders aren't working? Then let's go for our backup: whitemasks
	var _whitemaskBlends = array_create_ext(4, function(i) /*=>*/ {return (i == 0) ? c_white : palette.outputColours[i - 1]});
	var _blendChannels = [ colour_get_red(image_blend) / 255, colour_get_green(image_blend) / 255, colour_get_blue(image_blend) / 255 ];
	
	for (var i = 0; i < 4; i++) {
		var _colour = make_color_rgb(
			(colour_get_red(_whitemaskBlends[i]) / 255) * _blendChannels[0] * 255,
			(colour_get_green(_whitemaskBlends[i]) / 255) * _blendChannels[1] * 255,
			(colour_get_blue(_whitemaskBlends[i]) / 255) * _blendChannels[2] * 255,
		);
		global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, i, x, y, image_xscale, image_yscale, _colour, image_alpha);
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
