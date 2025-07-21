if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (weaponIconTimer > 0) {
	colour_replacer()
		.activate(ColourReplacerMode.GREYSCALE)
		.set_colour_count(PaletteWeapon.sizeof)
		.apply_output_colours(weapon.colours)
		.update_uniforms();
	weapon.draw_icon(x - 8, y - 30 * image_yscale);
	colour_replacer().deactivate();
}

x = _x;
y = _y;
