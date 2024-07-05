if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if ((iFrames mod 4) < 2 || !iFrames)
	onDraw(false);
else if (hitsparkEffect)
	draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), 1, 1, 0, c_white, 1);
else
	onDraw(true);

x = _x;
y = _y;
