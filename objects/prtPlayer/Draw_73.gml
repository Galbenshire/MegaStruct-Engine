if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (weaponIconTimer > 0 && !is_undefined(weapon)) {
	paletteCache.activate();
	weapon.draw_icon(x - 8, y - 30 * image_yscale);
	paletteCache.deactivate();
}

x = _x;
y = _y;
