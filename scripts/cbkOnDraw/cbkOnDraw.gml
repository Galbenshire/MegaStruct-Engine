// These are base callbacks for `onDraw`
// As the name suggests, `onDraw` will be called when it's time to draw an entity.
//
// By default, this will occur in the Draw Event, and the following will already be accounted for:
// - If the entity can even be drawn this frame  (e.g. they might be dead)
// - Whether or not they're in a subpixel position
// - Whether or not they're experiencing white-flashing from i-frames
//
// == Parameters
// whiteflash (bool) - Determines if the entity has a white-flash effect (true) or not (false)
//      This would be important for if you're using shaders to draw
//

#region Base Callbacks

/// @func cbkOnDraw_prtEntity(whiteflash)
/// @desc Default onDraw callback for all entities
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_prtEntity(_whiteflash) {
    draw_self();
}

/// @func cbkOnDraw_prtPlayer(whiteflash)
/// @desc Default onDraw callback for players.
///       prtPlayer calls onDraw a bit differently from regular entities;
///       the `whiteflash` variable is not used here
///
/// @param {bool}  whiteflash  Unused here
function cbkOnDraw_prtPlayer(_whiteflash) {
	var _colReplacer = colour_replacer(),
		_spriteAtlas = global.spriteAtlas_Player;
	_spriteAtlas.sprite = skinSprite;
	
	if (_colReplacer.IS_SUPPORTED) {
		_colReplacer.activate(palette);
        _spriteAtlas.draw_cell_ext(skinCellX, skinCellY, 0, x, y, image_xscale, image_yscale, image_blend, image_alpha);
        _colReplacer.deactivate();
        return;
	}
	
	// Shaders aren't working? Then let's go for our backup: whitemasks
	var _whitemaskBlends = array_create_ext(4, function(i) /*=>*/ {return (i == 0) ? c_white : palette.outputColours[i - 1]}),
		i = 0;
	repeat(4) {
		var _colour = multiply_colours(image_blend, _whitemaskBlends[i]);
		_spriteAtlas.draw_cell_ext(skinCellX, skinCellY, i, x, y, image_xscale, image_yscale, _colour, image_alpha);
		i++;
	}
}

#endregion

#region Available Presets

/// @func cbkOnDraw_colourReplacer(whiteflash)
/// @desc onDraw callback preset for when an entity uses a ColourReplacer palette
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_colourReplacer(_whiteflash) {
    if (_whiteflash || is_undefined(palette)) {
        draw_self();
    } else {
		var _colReplacer = colour_replacer();
        _colReplacer.activate(palette);
        draw_self();
        _colReplacer.deactivate();
    }
}

#endregion