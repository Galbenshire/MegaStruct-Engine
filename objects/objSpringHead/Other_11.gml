/// @description Gabyoall Movement
xcoll = 0;
xcollInstance = noone;
hasReachedEdge = false;

var _totalSpeed = xspeed + externalXForce;
while (abs(_totalSpeed) > 0) {
    var _step = abs(_totalSpeed) > 1 ? sign(_totalSpeed) : _totalSpeed;
    xcollInstance = move_and_collide_x(_step);
    entity_check_ground(gravDir);
    
    if (xcollInstance != noone) {
        xcoll = xspeed;
		subPixelX = xcollInstance.subPixelX;
		xspeed = 0;
		break;
    }
    
    var _mask = mask_index,
        _x = x,
        _y = y;
    mask_index = sprDot;
    x += 8 * sign(_step);
    y -= gravDir;
    if (entity_check_ground(gravDir, true, true) == noone && !check_for_solids_point(x, y, self)) {
        if (!check_for_solids_point(x - 16  * sign(_step), y - gravDir, self)) {
            xspeed = 0;
            hasReachedEdge = true;
            _totalSpeed = 0;
        }
    }
    x = _x;
    y = _y;
    mask_index = _mask;
    
    _totalSpeed = approach(_totalSpeed, 0, 1);
}