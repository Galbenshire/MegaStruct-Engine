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

/// @func restart_room(instant)
/// @desc Resets the current room
function restart_room(_instant = false) {
	go_to_room(room, _instant);
}
