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

/// @func cbkOnDraw_prtBoss(whiteflash)
/// @desc Default onDraw callback for bosses
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_prtBoss(_whiteflash) {
	if (!isTeleporting) {
		draw_self();
		return;
	}
	
	var _colReplacer = colour_replacer(),
		_teleportPaletteMode = teleportPalette.colourMode;
	
	if (!_whiteflash && _colReplacer.is_mode_supported(_teleportPaletteMode)) {
		_colReplacer.activate(_teleportPaletteMode)
			.apply_palette(teleportPalette)
			.update_uniforms();
		draw_sprite(teleportSprite, teleportImg, x, y);
		_colReplacer.deactivate();
	} else {
		draw_sprite(teleportSprite, teleportImg, x, y);
	}
}

/// @func cbkOnDraw_prtPlayer(whiteflash)
/// @desc Default onDraw callback for players.
///       prtPlayer calls onDraw a bit differently from regular entities;
///       the `whiteflash` variable is not used here
///
/// @param {bool}  whiteflash  Unused here
function cbkOnDraw_prtPlayer(_whiteflash) {
	var _colReplacer = colour_replacer(),
		_paletteMode = palette.colourMode,
		_skinSprite = characterSpecs.playerSprites[skinSprite];
	
	if (!_whiteflash && _colReplacer.is_mode_supported(_paletteMode)) {
		_colReplacer.activate(_paletteMode)
			.apply_palette(palette)
			.update_uniforms();
		draw_sprite_ext(_skinSprite, skinIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		_colReplacer.deactivate();
	} else {
		draw_sprite_ext(_skinSprite, skinIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
}

#endregion

#region Available Presets

/// @func cbkOnDraw_colourReplacer(whiteflash)
/// @desc onDraw callback preset for when an entity uses a ColourReplacer palette
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_colourReplacer(_whiteflash) {
	var _colReplacer = colour_replacer(),
		_paletteMode = palette.colourMode;
	
	if (!_whiteflash && _colReplacer.is_mode_supported(_paletteMode)) {
		_colReplacer.activate(_paletteMode)
			.apply_palette(palette)
			.update_uniforms();
		draw_self();
		_colReplacer.deactivate();
	} else {
		draw_self();
	}
}

/// @func cbkOnDraw_enemyBulletMM1(whiteflash)
/// @desc onDraw callback preset for drawing a MM1-style enemy bullet, with two configurable colours
///
/// @param {bool}  whiteflash  If true, the entity is currently flashing white
function cbkOnDraw_enemyBulletMM1(_whiteflash) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, colours[0], image_alpha);
    draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, image_yscale, image_angle, colours[1], image_alpha);
}

#endregion