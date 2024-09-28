if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (iFrames < 0 || (iFrames & 3) < 2) {
	if (isHurt && (hitTimer & 7) <= 3)
		draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), image_xscale, image_yscale, 0, c_white, 1);
	else
		onDraw();
}

x = _x;
y = _y;