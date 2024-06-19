if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (iFrames < 0 || (iFrames & 3) < 2) {
	bodyPalette.activate();
	global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, 0, x, y, image_xscale, image_yscale, c_white, 1);
	bodyPalette.deactivate();
}

x = _x;
y = _y;
