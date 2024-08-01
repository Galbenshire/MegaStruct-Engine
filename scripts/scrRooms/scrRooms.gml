/// @func go_to_level(level)
/// @desc Takes the game to a room tagged as a level, performing any extra steps necessary
///
/// @param {room}  level  The level to go to (make sure it has the "room_level" tag)
function go_to_level(_level) {
	assert(is_room_level(_level), "calling go_to_level to a room not tagged as a level");
	
	objSystem.level.__startLevel = true;
	go_to_room(_level);
}

/// @func go_to_room(room, instant)
/// @desc Helper function to switch rooms
///
/// @param {room}  room  The new room to go to
/// @param {bool}  [instant]  If true, the screenfade is skipped. Defaults to false.
function go_to_room(_room, _instant = false) {
	if (_instant) {
		global.previousRoom = room;
		room_goto(_room);
		return;
	}
	
	screen_fade({
		persistent: true,
		nextRoom: _room,
		onFadeInStart: function(_fader) {
			global.previousRoom = room;
			room_goto(_fader.nextRoom);
		}
	});
}

/// @func is_room_level(room)
/// @desc Checks if the given room is tagged as a level
///
/// @param {room}  room  The room to check
///
/// @return {bool}  Whether this room is a level (true) or not (false)
function is_room_level(_room) {
	return asset_has_tags(_room, "room_level", asset_room);
}

/// @func restart_room(instant)
/// @desc Resets the current room
///
/// @param {bool}  [instant]  If true, the screenfade is skipped. Defaults to false.
function restart_room(_instant = false) {
	go_to_room(room, _instant);
}
