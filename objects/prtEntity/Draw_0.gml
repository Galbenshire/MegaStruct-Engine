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

if (_iFrameInterval == 1) {
	gpu_set_fog(true, c_white, 0, 0);
	onDraw(true);
	gpu_set_fog(false, 0, 0, 0);
} else if (frozenTimer > 42 || (frozenTimer > 0 && frozenTimer mod 4 == 0)) {
	gpu_set_fog(true, $FF7800, 0, 0);
	onDraw(true);
	gpu_set_fog(false, 0, 0, 0);
	
	gpu_set_blendmode(bm_add);
    onDraw(false);
    gpu_set_blendmode(bm_normal);
} else {
	onDraw(false);
}

x = _x;
y = _y;
