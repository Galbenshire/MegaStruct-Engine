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
	
	array_foreach(asset_get_ids(asset_shader), function(_shader, i) {
		var _shaderName = shader_get_name(_shader),
			_shaderCompiled = shader_is_compiled(_shader);
		struct_set(global.shadersCompiled, _shaderName, _shaderCompiled);
		if (!_shaderCompiled)
			print_err($"ERROR: Shader {_shaderName} did not compile");
	});
	
	// ===== Custom Assets =====
	show_debug_message("Building Custom Assets...");
	
	// Standard assets
	global.font = font_add_sprite(sprFontMM9, ord(" "), false, 0); /// @is {font}
	global.musicTracks = __init_jukebox();
	
	// Caching stuff
	global.characterList = cache_game_assets("Character");
	global.characterEntityList = cache_character_entities();
	global.weaponList = cache_game_assets("Weapon");
	
	// Random Drop Tale
	global.randomDropTable = [ objHealthEnergyBig, objWeaponEnergyBig, objHealthEnergySmall, objWeaponEnergySmall, objBoltBig, objBoltSmall, noone ];
	global.randomDropWeights = [ 20, 20, 25, 25, 25, 120, 480 ];
	
	// ===== Global Variables =====
	show_debug_message("Generating Global Variables...");
	
	// Global Player Stats
	global.bolts = 0;
	
	// Likely to change a lot
	global.gameTimeScale = new Fractional(1); /// @is {Fractional}
	global.previousRoom = room; /// @is {room}
	global.paused = false; /// @is {bool}
	global.pauseMenuActive = false;
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
	
	// ===== Load Settings =====
	options_data().load_from_file();
	game_window().update_screen();
	game_window().center_window();
	
	// ===== Setup Some Debug Views =====
	if (DEBUG_ENABLED) {
		__debug_view_instance_count();
		__debug_view_locks();
		__debug_view_options_data();
		__debug_view_player();
		__debug_view_room_select();
		__debug_view_screen_effects();
		__debug_view_timers();
		show_debug_overlay(false);
	}
	
	// ===== Other Stuff =====
	show_debug_message("Other Operations...");
	math_set_epsilon(0.0001);
	window_set_caption("MegaStruct Engine");
	
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