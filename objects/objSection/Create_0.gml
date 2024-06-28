var _roomName = room_get_name(room);

assert(sprite_width >= GAME_WIDTH, "{0} contains a section whose width is too small to be usable", _roomName);
assert(sprite_height >= GAME_HEIGHT, "{0} contains a section whose height is too small to be usable", _roomName);

// Bounds
left = bbox_left;
top = bbox_top;
right = bbox_right;
bottom = bbox_bottom;
