/// @func go_to_level(level)
function go_to_level(_level) {
	assert(is_room_level(_level), "calling go_to_level to a room not tagged as a level");
	
	objSystem.level.__startLevel = true;
	go_to_room(_level);
}

/// @func go_to_room(room, instant)
/// @desc Helper function to switch rooms
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

/// @func is_room_level()
function is_room_level(_room) {
	return asset_has_tags(_room, "room_level", asset_room);
}

/// @func restart_room(instant)
/// @desc Resets the current room
function restart_room(_instant = false) {
	go_to_room(room, _instant);
}
