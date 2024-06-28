event_inherited();

// Check for overlaps with other splashes
if (!allowSplashOverlap) {
	image_xscale *= 0.2;
	
	if (place_meeting(x, y, objSplash)) {
		instance_destroy();
		exit;
	}
	
	image_xscale *= 5;
}

if (playSplashSFX)
    play_sfx(sfxSplash);

if (!instance_exists(waterInstance))
    exit;

// Clamp the splash within the water instance its tied to
if ((image_angle div 90) & 1) { // Vertical Splash
    var _overflowTop = waterInstance.bbox_top - bbox_top,
		_overflowBottom = bbox_bottom - waterInstance.bbox_bottom;
	
	if (_overflowTop > 0 && _overflowBottom > 0)
		y = bbox_y_center(waterInstance);
	else
		y += max(0, _overflowTop) - max(0, _overflowBottom);
} else { // Horizontal Splash
    var _overflowLeft = waterInstance.bbox_left - bbox_left,
		_overflowRight = bbox_right - waterInstance.bbox_right;
	
	if (_overflowLeft > 0 && _overflowRight > 0)
		x = bbox_x_center(waterInstance);
	else
		x += max(0, _overflowLeft) - max(0, _overflowRight);
}