/// @func __debug_view_instance_count()
function __debug_view_instance_count() {
	DEBUG_VIEW_HTML5_CHECK
	
	var _debugSystem = objSystem.debug;
	
	// == The View
	var _view = dbg_view("Instance Count", false, -1, -1, 475, 300);
	
	// -- Section - Main
	var _main = dbg_section("Main");
	dbg_watch(ref_create(_debugSystem, "instanceCountActive"), "Instance Count (Current): ");
	dbg_watch(ref_create(_debugSystem, "instanceCountRoomStart"), "Instance Count (On Room Start): ");
	
	// -- Section - Snapshot
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
			
			for (var i = 0, n = array_length(_objects); i < n; i++) {
				var _line_split = string_split(_objects[i], "||");
				instanceListNames += _line_split[0];
				instanceListCounts += string("\t\t{0}", _line_split[1]);
				
				if (i != n - 1) {
					instanceListNames += "\n";
					instanceListCounts += "\n";
				}
			}
		}
	});
	dbg_text(ref_create(_debugSystem, "instanceListNames"));
	dbg_same_line();
	dbg_text(ref_create(_debugSystem, "instanceListCounts"));
}

/// @func __debug_view_locks()
function __debug_view_locks() {
	DEBUG_VIEW_HTML5_CHECK
	
	// == The View
    var _view = dbg_view("Locks", false, -1, -1, 300, 150);
    
    // -- Section - Pause
    var _pauseLock = dbg_section("Pause");
    dbg_watch(ref_create(objSystem.level.pauseStack, "counter"), "Locks: ");
    
    // -- Section - Player Inputs
    var _pauseLock = dbg_section("Player Inputs");
    dbg_watch(ref_create(global.player.lockpool, "results"), "Lock Results: ");
}

/// @func __debug_view_options_data()
function __debug_view_options_data() {
    DEBUG_VIEW_HTML5_CHECK
	
	var _options = options_data();
	
    var _view = dbg_view("Options Data", false, -1, -1, 340, 480);
    
    var _display = dbg_text_separator("Display");
    dbg_slider_int(ref_create(_options, "screenSize"), 1, floor(_options.MAX_SCALE), "Screen Size");
    dbg_checkbox(ref_create(_options, "fullscreen"), "Fullscreen");
    dbg_checkbox(ref_create(_options, "pixelPerfect"), "Pixel Perfect");
    dbg_checkbox(ref_create(_options, "vsync"), "VSync");
    dbg_checkbox(ref_create(_options, "showFPS"), "Show FPS");
    dbg_button("Update Screen", function() {
		game_window().update_screen();
		game_window().center_window();
	});
    
    var _volume = dbg_text_separator("Volume");
    dbg_slider(ref_create(_options, "volumeMaster"), 0, 1, "Master");
    dbg_slider(ref_create(_options, "volumeMusic"), 0, 1, "Music");
    dbg_slider(ref_create(_options, "volumeSound"), 0, 1, "Sound");
    
    var _controls = dbg_text_separator("Controls");
    dbg_checkbox(ref_create(_options, "downJumpSlide"), "Down+Jump Slide");
    dbg_checkbox(ref_create(_options, "autoFire"), "Auto Fire");
    dbg_checkbox(ref_create(_options, "chargeToggle"), "Charge Toggle");
    
    var _controls = dbg_text_separator("Other");
    dbg_slider(ref_create(_options, "gameSpeed"), 0.1, 2, "Game Speed", 0.01);
    dbg_checkbox(ref_create(_options, "chargeBar"), "Charge Bar");
    dbg_checkbox(ref_create(_options, "instantHealthFill"), "Instant Health Fill");
    dbg_checkbox(ref_create(_options, "damagePopup"), "Damage Popup");
}

/// @func __debug_view_player()
function __debug_view_player() {
	DEBUG_VIEW_HTML5_CHECK
	
	var _player = global.player;
	
	// == The View
	var _view = dbg_view("Player", false, -1, -1, 400, 275);
	
	// -- Section - Data
	var _shortcuts = dbg_section("General");
	dbg_slider_int(ref_create(_player, "characterID"), 0, CharacterType.COUNT - 1, "Character ID: ");
	
	// -- Section - Inputs
	var _inputs = dbg_section("Input");
	dbg_watch(ref_create(_player.inputs, "held"), "Held: ");
	dbg_watch(ref_create(_player.inputs, "pressed"), "Pressed: ");
	dbg_watch(ref_create(_player.inputs, "released"), "Released: ");
	
	// -- Section - Actions
	var _actions = dbg_section("Actions");
	//
	dbg_button("Press 2", function() {
		with (global.player.body)
			entity_kill_self();
	});
	dbg_same_line();
	dbg_button("Kill Entities", function() {
		play_sfx(sfxExplosionMM3);
		with (prtEntity) {
			if (entity_can_take_damage(true) && bitmask_has_bit(factionLayer, Faction.ENEMY))
				entity_kill_self();
		}
	});
}

/// @func __debug_view_room_select()
function __debug_view_room_select() {
	DEBUG_VIEW_HTML5_CHECK
	
	var _view = dbg_view("Rooms", false, -1, -1, 400, 250);
	
	var _shortcuts = dbg_section("Shortcuts");
	dbg_button("Title Screen", function() /*=>*/ { go_to_room(mnuTitleScreen); });
	dbg_same_line();
	dbg_button("Spritesheet Test", function() /*=>*/ { go_to_room(mnuPlayerSpritesheetTest); });
	
	var _roomIDs = asset_get_ids(asset_room),
		_roomList = array_map(asset_get_ids(asset_room), function(_room, i) /*=>*/ {return string("{0}:{1}", room_get_name(_room), int64(_room))});
	array_sort(_roomList, true);
	
	var _currentRoom = dbg_section("Selector");
	dbg_watch(ref_create(global, "roomName"), "Current Room: ");
	dbg_drop_down(ref_create(global, "nextRoom"), string_join_ext(",", _roomList), "Next Room:");
	dbg_button("Go to Next Room", function () {
		if (is_room_level(global.nextRoom))
			go_to_level(global.nextRoom);
		else
			go_to_room(global.nextRoom);
	});
}

/// @func __debug_view_screen_effects()
function __debug_view_screen_effects() {
	DEBUG_VIEW_HTML5_CHECK
	
	var _debugSystem = objSystem.debug;
	
	// == The View
	var _view = dbg_view("Screen Effects", false, -1, -1, 400, 400);
	
	// -- Flash
	var _flash = dbg_section("Flash");
    dbg_slider_int(ref_create(_debugSystem, "flashDuration"), 0, 120, "Duration: ");
    dbg_colour(ref_create(_debugSystem, "flashCol"), "Colour: ");
    dbg_slider(ref_create(_debugSystem, "flashDecay"), 0, 1, "Decay: ");
    dbg_slider(ref_create(_debugSystem, "flashGain"), 0, 1, "Gain: ");
    dbg_slider(ref_create(_debugSystem, "flashStep"), 0, 1, "Step: ", 0.1);
    dbg_button("Do Flash", function () {
		with (objSystem.debug)
			screen_flash(flashDuration, flashCol, flashDecay, flashGain, flashStep);
	});
	
	// -- Shake
	var _shake = dbg_section("Shake");
    dbg_slider_int(ref_create(_debugSystem, "shakeDuration"), 0, 120, "Duration: ");
    dbg_slider(ref_create(_debugSystem, "shakeStrengthX"), 0, 8, "Strength (X): ");
    dbg_slider(ref_create(_debugSystem, "shakeStrengthY"), 0, 8, "Strength (Y): ");
    dbg_slider(ref_create(_debugSystem, "shakeDecay"), 0, 1, "Decay: ");
    dbg_button("Do Shake", function () {
		with (objSystem.debug)
			screen_shake(shakeDuration, shakeStrengthX, shakeStrengthY, shakeDecay);
	});
}

/// @func __debug_view_timers()
function __debug_view_timers() {
	DEBUG_VIEW_HTML5_CHECK
	
	// == The View
	var _view = dbg_view("Timers", false, -1, -1, 250, 200);
	
	// -- Section - System
	var _system = dbg_section("System");
	dbg_watch(ref_create(global, "roomTimer"), "Room: ");
	dbg_watch(ref_create(global, "sessionTimer"), "Session: ");
	dbg_watch(ref_create(global, "systemTimer"), "System: ");
	
	// -- Section - Stopwatch
	var _debugSystem = objSystem.debug;
	var _stopwatch = dbg_section("Stopwatch");
	dbg_watch(ref_create(_debugSystem, "stopwatchTimer"), "Stopwatch: ");
	dbg_checkbox(ref_create(_debugSystem, "stopwatchActive"), "Is Active");
	dbg_button("Reset", function() /*=>*/ { objSystem.debug.stopwatchTimer = 0; });
}
