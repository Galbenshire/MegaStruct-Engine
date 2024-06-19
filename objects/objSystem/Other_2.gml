/// @description Game Init
// ===== This should only run once =====
if (!variable_global_exists("__gameInit")) {
	show_debug_message("Initialising...");
	
	// ===== Custom Assets =====
	show_debug_message("Building Custom Assets...");
	global.font = font_add_sprite(sprFontMM9, ord(" "), false, 0); /// @is {font}
	global.spriteAtlas_Player = new SpriteAtlas({
		sprite: sprPlayerSkinRockMan,
		width: 50,
		margin: 1,
		padding: 2,
		xoffset: 25,
		yoffset: 21
	}); /// @is {SpriteAtlas}
	
	// ===== Global Variables =====
	show_debug_message("Generating Global Variables...");
	
	// Likely to change a lot
	global.gameTimeScale = new Fractional(1); /// @is {Fractional}
	global.roomName = room_get_name(room); /// @is {string}
	global.roomIsLevel = false; /// @is {bool}
	global.previousRoom = room; /// @is {room}
	global.paused = false; /// @is {bool}
	global.switchingSections = false; /// @is {bool}
	
	// Unlikely to change that much, if at all
	global.player = new Player(0);
	global.osInfo = os_get_info(); /// @is {ds_map}
	
	// Not intended to be accessed outside of system-specific code
	global.__collisionList = ds_list_create(); /// @is {ds_list}
	
	// ===== Load Settings =====
	options_data().load_from_file();
	game_window().update_screen();
	game_window().center_window();
	
	// ===== Setup Some Debug Views =====
	options_data().debug_view();
	show_debug_overlay(false);
	
	// ===== Other Stuff =====
	show_debug_message("Other Operations...");
	math_set_epsilon(0.0001);
	surface_depth_disable(true);
	
	// ===== Finish =====
	show_debug_message("...Initialisation Finished");
	global.__gameInit = true;
}

// ===== Reset various global variables =====
global.paused = false;

// =====  Other Operations =====
draw_set_font(global.font); // This gets reset when the game is restarted