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

/// @func cbkOnDraw_base()
/// @desc Default onDraw callback for all entities
function cbkOnDraw_base() {
    draw_self();
}

#endregion

#region Available Presets

/// @func cbkOnDraw_colour_replacer()
/// @desc onDraw callback preset for when an entity uses a ColourReplacer palette
function cbkOnDraw_colour_replacer() {
	var _colReplacer = colour_replacer(),
		_paletteMode = palette.colourMode;
	
	if (!FOG_ENABLED && _colReplacer.is_mode_supported(_paletteMode)) {
		_colReplacer.activate(_paletteMode)
			.apply_palette(palette)
			.update_uniforms();
		draw_self();
		_colReplacer.deactivate();
	} else {
		draw_self();
	}
}

/// @func cbkOnDraw_enemy_bullet_mm1()
/// @desc onDraw callback preset for drawing a MM1-style enemy bullet, with two configurable colours
function cbkOnDraw_enemy_bullet_mm1() {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, colours[0], image_alpha);
    draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, image_yscale, image_angle, colours[1], image_alpha);
}



/// @func cbkOnDraw_player()
/// @desc Default onDraw callback for players
function cbkOnDraw_player() {
	var _colReplacer = colour_replacer(),
		_paletteMode = palette.colourMode,
		_skinSprite = characterSpecs.get_sprite(skinSprite),
		_skinIndex = characterSpecs.get_image_index(skinSprite, skinIndex, skinOffset);
	
	if (!FOG_ENABLED && _colReplacer.is_mode_supported(_paletteMode)) {
		_colReplacer.activate(_paletteMode)
			.apply_palette(palette)
			.update_uniforms();
		draw_sprite_ext(_skinSprite, _skinIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		_colReplacer.deactivate();
	} else {
		draw_sprite_ext(_skinSprite, _skinIndex, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
}

#endregion