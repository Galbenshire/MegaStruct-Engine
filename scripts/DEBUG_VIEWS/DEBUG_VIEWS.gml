/// @func __debug_view_options_data()
function __debug_view_options_data() {
    if (is_html5()) // Debug Views don't work on HTML5
		return;
	
	var _options = options_data();
	
    var _view = dbg_view("Options Data", false, -1, -1, 340, 450);
    
    var _display = dbg_section("Display");
    dbg_slider_int(ref_create(_options, "screenSize"), 1, floor(_options.MAX_SCALE), "Screen Size");
    dbg_checkbox(ref_create(_options, "fullscreen"), "Fullscreen");
    dbg_checkbox(ref_create(_options, "pixelPerfect"), "Pixel Perfect");
    dbg_checkbox(ref_create(_options, "vsync"), "VSync");
    dbg_checkbox(ref_create(_options, "showFPS"), "Show FPS");
    dbg_button("Update Screen", function() {
		game_window().update_screen();
		game_window().center_window();
	});
    
    var _volume = dbg_section("Volume");
    dbg_slider(ref_create(_options, "volumeMaster"), 0, 1, "Master");
    dbg_slider(ref_create(_options, "volumeMusic"), 0, 1, "Music");
    dbg_slider(ref_create(_options, "volumeSound"), 0, 1, "Sound");
    
    var _controls = dbg_section("Controls");
    dbg_checkbox(ref_create(_options, "downJumpSlide"), "Down+Jump Slide");
    dbg_checkbox(ref_create(_options, "autoFire"), "Auto Fire");
    dbg_checkbox(ref_create(_options, "chargeToggle"), "Charge Toggle");
    
    var _controls = dbg_section("Other");
    dbg_slider(ref_create(_options, "gameSpeed"), 0.1, 2, "Game Speed");
}

/// @func __debug_view_room_select()
function __debug_view_room_select() {
	if (is_html5()) // Debug Views don't work on HTML5
		return;
	
	var _roomIDs = asset_get_ids(asset_room),
		_roomList = array_map(_roomIDs, function(_room, i) /*=>*/ {return string("{0}:{1}", room_get_name(_room), int64(_room))});
	array_sort(_roomList, true);
	
	var _view = dbg_view("Room Selector", false, -1, -1, 400, 200);
	
	var _currentRoom = dbg_section("Current Room");
	dbg_watch(ref_create(global, "roomName"), "Current Room: ");
	
	var _nextRoom = dbg_section("Next Room");
	dbg_drop_down(ref_create(global, "nextRoom"), string_join_ext(",", _roomList), "Select Room");
	dbg_button("Go to Room", function() /*=>*/ { go_to_room(global.nextRoom); });
}
