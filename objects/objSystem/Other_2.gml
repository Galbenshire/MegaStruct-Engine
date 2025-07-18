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
	global.spriteAtlas_Player = new SpriteAtlas({
		sprite: sprPlayerSkinRockMan,
		width: 50,
		margin: 0,
		padding: 2,
		xoffset: 25,
		yoffset: 21
	}); /// @is {SpriteAtlas}
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
	global.roomTimer = 0; /// @is {int}
	global.systemTimer = 0; /// @is {int}
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
	__debug_view_instance_count();
	__debug_view_options_data();
	__debug_view_room_select();
	show_debug_overlay(false);
	
	// ===== Other Stuff =====
	show_debug_message("Other Operations...");
	math_set_epsilon(0.0001);
	
	// ===== Finish =====
	show_debug_message("...Initialisation Finished");
	global.__gameInit = true;
}

// ===== Reset various global variables =====
global.paused = false;

// =====  Other Operations =====
draw_set_font(global.font); // This gets reset when the game is restarted