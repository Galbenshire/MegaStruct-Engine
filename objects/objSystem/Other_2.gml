/// @description Game Init
// ===== This should only run once =====
if (!variable_global_exists("__gameInit")) {
	show_debug_message("Initialising...");
	
	// ===== Check all our shaders in the system managed to compile =====
	show_debug_message("Verifying shaders...");
	
	global.shadersSupported = shaders_are_supported(); /// @is {bool}
	global.shadersCompiled = {}; /// @is {struct}
	
	if (!global.shadersSupported)
		print_err("ERROR: Shaders not supported on your system");
	
	var _shaders = asset_get_ids(asset_shader),
		_shaderCount = array_length(_shaders);
	for (var i = 0; i < _shaderCount; i++) {
		var _shaderName = shader_get_name(_shaders[i]),
			_shaderCompiled = shader_is_compiled(_shaders[i]);
		
		struct_set(global.shadersCompiled, _shaderName, _shaderCompiled);
		
		if (!_shaderCompiled)
			print_err($"ERROR: Shader {_shaderName} did not compile");
	}
	
	// ===== Custom Assets =====
	show_debug_message("Building Custom Assets...");
	global.font = font_add_sprite(sprFontMM9, ord(" "), false, 0); /// @is {font}
	global.musicTracks = __init_jukebox();
	
	// ===== Global Variables =====
	show_debug_message("Generating Global Variables...");
	
	// Global Player Stats
	global.bolts = 0;
	
	// Likely to change a lot
	global.gameTimeScale = new Fractional(1); /// @is {Fractional}
	global.previousRoom = room; /// @is {room}
	global.paused = false; /// @is {bool}
	global.roomName = room_get_name(room); /// @is {string}
	global.roomIsLevel = false; /// @is {bool}
	global.section = noone; /// @is {objSection}
	global.switchingSections = false; /// @is {bool}
	global.roomTimer = 0; /// @is {int} Timer that resets on room change
	global.sessionTimer = 0; /// @is {int} Timer that resets on game restart
	global.systemTimer = 0; /// @is {int} Timer that is always running until the game is turned off
	global.hitStunTimer = 0; /// @is {int}
	
	// Unlikely to change that much, if at all
	global.nextRoom = room; /// @is {room}
	global.osInfo = os_get_info(); /// @is {ds_map}
	global.player = new Player(0); /// @is {Player}
	global.stopwatchActive = false; /// @is {bool}
	global.stopwatchTimer = 0; /// @is {int}
	
	// ===== Load Settings =====
	options_data().load_from_file();
	game_window().update_screen();
	game_window().center_window();
	
	// ===== Setup Some Debug Views =====
	if (DEBUG_ENABLED) {
		__debug_view_instance_count();
		__debug_view_options_data();
		__debug_view_room_select();
		__debug_view_timers();
		show_debug_overlay(false);
	}
	
	// ===== Other Stuff =====
	show_debug_message("Other Operations...");
	math_set_epsilon(0.0001);
	
	// ===== Finish =====
	show_debug_message("...Initialisation Finished");
	global.__gameInit = true;
}

// ===== Reset various global variables =====
global.sessionTimer = 0;
global.paused = false;
global.bolts = 0;

// =====  Other Operations =====
draw_set_font(global.font); // This gets reset when the game is restarted
options_data().change_master_volume(0);
options_data().change_music_volume(0);
options_data().change_sound_volume(0);