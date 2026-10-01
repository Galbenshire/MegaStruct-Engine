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
