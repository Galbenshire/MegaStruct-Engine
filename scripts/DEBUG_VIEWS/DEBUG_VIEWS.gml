/// @func __debug_view_instance_count()
function __debug_view_instance_count() {
	DEBUG_VIEW_HTML5_CHECK
	
	var _debug = objSystem.debug;
	
	var _view = dbg_view("Instance Count", false, -1, -1, 475, 300);
	
	var _main = dbg_section("Main");
	dbg_watch(ref_create(_debug, "instanceCountActive"), "Instance Count (Current): ");
	dbg_watch(ref_create(_debug, "instanceCountRoomStart"), "Instance Count (On Room Start): ");
	
	var _snapshot = dbg_section("Snapshot");
	dbg_button("Take Snapshot", function() {
		var _objects = [];
		with (all) {
			var _line = string("{0}||{1}", object_get_name(object_index), instance_number(object_index));
			if (!array_contains(_objects, _line))
				array_push(_objects, _line);
		}
		array_sort(_objects, true);
		
		with (objSystem.debug) {
			instanceListNames = "---- Objects ----\n";
			instanceListCounts = "---- Counts ----\n";
			
			var _count = array_length(_objects);
			for (var i = 0; i < _count; i++) {
				var _line_split = string_split(_objects[i], "||");
				instanceListNames += _line_split[0];
				instanceListCounts += string("\t\t{0}", _line_split[1]);
				
				if (i != _count - 1) {
					instanceListNames += "\n";
					instanceListCounts += "\n";
				}
			}
		}
	});
	dbg_text(ref_create(_debug, "instanceListNames"));
	dbg_same_line();
	dbg_text(ref_create(_debug, "instanceListCounts"));
}

/// @func __debug_view_options_data()
function __debug_view_options_data() {
    DEBUG_VIEW_HTML5_CHECK
	
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
	DEBUG_VIEW_HTML5_CHECK
	
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
