if (entity_is_dead())
	exit;

// 0 = don't draw; 1 = i-frame flash; 2 = draw normally
var _iFrameInterval = (iFrames <= 0) ? 2 : ((iFrames + 1) >> 1) & 3;
if (_iFrameInterval == 0)
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (_iFrameInterval == 2) {
	draw_self();
	//onDraw(false);
} else {
	gpu_set_fog(true, c_white, 0, 0);
	draw_self();
	//onDraw(true);
	gpu_set_fog(false, 0, 0, 0);
}

x = _x;
y = _y;
