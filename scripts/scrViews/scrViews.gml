#region Inside View/Section

/// @func inside_section(scope, x, y)
/// @desc Checks if the specified instance is within the current section.
///
/// @param {instance}  [scope]  The instance to check against. Defaults to the calling instance.
/// @param {number}  [x]  x-coordinate to check. Defaults to the instance's own x-position.
/// @param {number}  [y]  y-coordinate to check. Defaults to the instance's own y-position.
///
/// @returns {bool}  If the instance is within the section (true), or not (false)
function inside_section(_scope = self, _x = _scope.x, _y = _scope.y) {
	var _section = global.section;
	if (!instance_exists(_section))
		return true;
	with (_scope)
		return place_meeting(_x, _y, _section);
	return false;
}

/// @func inside_section_point(x, y)
/// @desc Checks if the given point is within the current section.
///
/// @param {number}  [x]  x-coordinate to check. Defaults to the calling instance's own x-position.
/// @param {number}  [y]  y-coordinate to check. Defaults to the calling instance's own y-position.
///
/// @returns {bool}  If the point is within the section (true), or not (false)
function inside_section_point(_x = x, _y = y) {
	var _section = global.section;
	if (!instance_exists(_section))
		return true;
	return position_meeting(_x, _y, _section);
}

/// @func inside_view(scope, x, y, margin)
/// @desc Checks if the specified instance is within view.
///		  By default, the check is done at the instance's current location, but a custom position can be specified.
///
/// @param {instance}  [scope]  The instance to check for. Defaults to the calling instance.
/// @param {number}  [x]  x-coordinate to check. Defaults to the instance's own x-position.
/// @param {number}  [y]  y-coordinate to check. Defaults to the instance's own y-position.
/// @param {number}  [margin]  The instance can be this many pixels away from the screen edge, and still be considered 'in view'
///
/// @returns {bool}  If the instance is within view (true), or not (false)
function inside_view( _scope = self, _x = _scope.x, _y = _scope.y, _margin = 0) {
	with (_scope) {
		var _stored_x = x,
			_stored_y = y;
		x = _x;
		y = _y;
		
		var _gameView = game_view();
		var _result = bbox_left <= _gameView.right_edge(_margin, false)
			&& bbox_right >= _gameView.left_edge(-_margin, false)
			&& bbox_top <= _gameView.bottom_edge(_margin, false)
			&& bbox_bottom >= _gameView.top_edge(-_margin, false);
		
		x = _stored_x;
		y = _stored_y;
		
		return _result;
	}
	
	return false; // Failsafe
}

/// @func inside_view_point(x, y, margin)
/// @desc Checks if the coordinate point is within view in the specified location.
///
/// @param {number}  [x]  x-coordinate to check. Defaults to the calling instance's own x-position.
/// @param {number}  [y]  y-coordinate to check. Defaults to the calling instance's own y-position.
/// @param {number}  [margin]  The coordinates can be this many pixels away from the screen edge, and still be considered 'in view'
///
/// @returns {bool}  If the coordinates are within view (true), or not (false)
function inside_view_point(_x = x, _y = y, _margin = 0) {
	var _gameView = game_view();
	return _x < _gameView.right_edge(_margin, false)
		&& _x >= _gameView.left_edge(-_margin, false)
		&& _y < _gameView.bottom_edge(_margin, false)
		&& _y >= _gameView.top_edge(-_margin, false);
}

#endregion

#region Screen Flash

/// @func screen_flash(duration, colour, decay, gain, step)
/// @desc Performs a screen flash
///		  NOTE: Be careful about how you use this. Some people might have photosensitive epilepsy.
///
/// @param {number}  duration  How long the shake should last.
/// @param {int}  [colour]  Colour of the flash. Defaults to white.
/// @param {number}  [decay]  How much to reduce the flash by after the duration. Defaults to 0 (end instantly).
/// @param {number}  [gain]  How much to increase the flash to full opacity. Defaults to 0 (start instantly).
/// @param {number}  [step]  Rounds the opacity of the flash when gaining/decaying. Defaults to 0 (no rounding).
function screen_flash(_duration, _colour = c_white, _decay = 0, _gain = 0, _step = 0) {
	var _flash = array_create(ScreenFlashNote.sizeof);
	_flash[ScreenFlashNote.alpha] = real(_gain <= 0);
	_flash[ScreenFlashNote.colour] = _colour;
	_flash[ScreenFlashNote.timer] = abs(_duration);
	_flash[ScreenFlashNote.gain] = max(_gain, 0);
	_flash[ScreenFlashNote.decay] = max(_decay, 0);
	_flash[ScreenFlashNote.step] = clamp(_step, 0, 1);
	_flash[ScreenFlashNote.isDone] = false;
	
	with (objSystem.flasher) {
		array_push(flashes, _flash);
		flashCount++;
	}
	
	return _flash;
}

/// @func stop_screen_flash(_flash)
/// @desc Stops a specific screen flash instance
///		  Normally used to stop a sustained screen flash
///
/// @param {ScreenFlashNote}  flash  The screen flash instance to stop
function stop_screen_flash(_flash) {
	_flash[ScreenFlashNote.isDone] = true;
}

/// @func stop_screen_flash_all()
/// @desc Tells the game to stop all instances of flashing the screen
function stop_screen_flash_all() {
	with (objSystem.flasher) {
		flashes = [];
		flashCount = 0;
	}
}

#endregion

#region Screen Shake

/// @func screen_shake(duration, strength_x, strength_y, decay)
/// @desc Performs a screen shake
///
/// @param {int}  duration  How long the shake should last.
/// @param {number}  strength_x  Horizontal strength of the shake
/// @param {number}  strength_y  Vertical strength of the shake
/// @param {number}  [decay]  How much to reduce the strengths by after the duration. Defaults to 0 (end instantly).
///
/// @returns {ScreenShakeNote}
function screen_shake(_duration, _strengthX, _strengthY, _decay = 0) {
	var _shake = array_create(ScreenShakeNote.sizeof);
	_shake[ScreenShakeNote.strengthX] = abs(_strengthX);
	_shake[ScreenShakeNote.strengthY] = abs(_strengthY);
	_shake[ScreenShakeNote.timer] = abs(_duration);
	_shake[ScreenShakeNote.decay] = max(_decay, 0);
	_shake[ScreenShakeNote.isDone] = false;
	
	with (objSystem.shaker) {
		array_push(shakes, _shake);
		shakeCount++;
	}
	
	return _shake;
}

/// @func stop_screen_shake(shake)
/// @desc Stops a specific screen shake instance
///		  Normally used to stop a sustained screen shake
///
/// @param {ScreenShakeNote}  shake  The screen shake instance to stop
function stop_screen_shake(_shake) {
	_shake[ScreenShakeNote.isDone] = true;
}

/// @func stop_screen_shake_all()
/// @desc Tells the game to stop all instances of shaking the screen
function stop_screen_shake_all() {
	with (objSystem.shaker) {
		shakes = [];
		shakeCount = 0;
	}
}

#endregion

#region Other

/// @func find_section_at(x, y)
/// @desc Finds an objSection at the given location
///
/// @param {number}  x  x-coordinate to find a section at
/// @param {number}  y  y-coordinate to find a section at
///
/// @returns {objSection}  The objSection at this position. Returns noone if nothing is found.
function find_section_at(_x, _y) {
	return instance_position(_x, _y, objSection);
}

#endregion
