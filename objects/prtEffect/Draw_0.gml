var _x = x,
	_y = y;

x += subPixelX;
y += subPixelY;

event_user(EVENT_EFFECT_DRAW_FRAME);

x = _x;
y = _y;
