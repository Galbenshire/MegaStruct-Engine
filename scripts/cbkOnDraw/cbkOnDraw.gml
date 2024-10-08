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
		_spriteAtlas = global.spriteAtlas_Player,
		_skinPage = characterSpecs.spritesheet_page_to_image_index(skinPage);
	
	_spriteAtlas.sprite = skinSprite;
	
	if (_colReplacer.IS_SUPPORTED) {
		_colReplacer.activate();
		_colReplacer.apply_palette(palette);
        _spriteAtlas.draw_cell_ext(skinCellX, skinCellY, _skinPage, x, y, image_xscale, image_yscale, image_blend, image_alpha);
        _colReplacer.deactivate();
	} else {
		_spriteAtlas.draw_cell_ext(skinCellX, skinCellY, _skinPage, x, y, image_xscale, image_yscale, image_blend, image_alpha);
	}
}

#endregion

#region Available Presets

/// @func cbkOnDraw_colourReplacer(whiteflash)
/// @desc onDraw callback preset for when an entity uses a ColourReplacer palette
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_colourReplacer(_whiteflash) {
    if (_whiteflash) {
        draw_self();
    } else {
		var _colReplacer = colour_replacer();
        _colReplacer.activate();
        _colReplacer.apply_palette(palette);
        draw_self();
        _colReplacer.deactivate();
    }
}

/// @func cbkOnDraw_enemyBulletMM1(whiteflash)
/// @desc onDraw callback preset for drawing a MM1-style enemy bullet, with two configurable colours
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_enemyBulletMM1(_whiteflash) {
    draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, image_angle, colours[0], image_alpha);
    draw_sprite_ext(sprite_index, 2, x, y, image_xscale, image_yscale, image_angle, colours[1], image_alpha);
}

#endregion