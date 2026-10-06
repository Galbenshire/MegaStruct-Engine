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
    
    var _rayStartX = bbox_horizontal(image_xscale),
		_rayStartY = bbox_top;
	var _rayEndX = _rayStartX,
		_rayEndY = bbox_bottom + 10;
	var _raycastResult = raycast_find(_rayStartX, _rayStartY, _rayEndX, _rayEndY);
	
	if (!_raycastResult.collided) {
		xspeed = 0;
        hasReachedEdge = true;
        _totalSpeed = 0;
	}
    
    _totalSpeed = approach(_totalSpeed, 0, 1);
}