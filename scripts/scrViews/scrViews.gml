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

/// @func screen_flash(duration, colour)
/// @desc Performs a screen flash
///		  NOTE: Be careful about how you use this. Some people might have photosensitive epilepsy.
///
/// @param {number}  duration  How long the shake should last.
/// @param {int}  [colour]  Colour of the flash. Defaults to white.
function screen_flash(_duration, _colour = c_white) {
	with (objSystem.flasher) {
		timer = _duration;
		colour = _colour;
	}
}

/// @func screen_shake(duration, strength_x, strength_y)
/// @desc Performs a screen shake
///
/// @param {number}  duration  How long the shake should last.
/// @param {number}  strength_x  Horizontal strength of the shake
/// @param {number}  strength_y  Vertical strength of the shake
function screen_shake(_duration, _strengthX, _strengthY) {
	with (objSystem.shaker) {
		timer = _duration;
		strengthX = _strengthX;
		strengthY = _strengthY;
	}
}

/// @func stop_screen_flash()
/// @desc Tells the game to stop flashing the screen
///		  Normally used to stop a sustained screen flash
function stop_screen_flash() {
	screen_flash(0);
}

/// @func stop_screen_shake()
/// @desc Tells the game to stop shaking the screen
///		  Normally used to stop a sustained screen shake
function stop_screen_shake() {
	screen_shake(0, 0, 0);
}
