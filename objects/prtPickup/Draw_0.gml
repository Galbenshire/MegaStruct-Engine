if (flashIndex >= 2 || entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

onDraw(false);

x = _x;
y = _y;
