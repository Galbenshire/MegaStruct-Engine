/// @description Game Init
// ===== This should only run once =====
if (!variable_global_exists("__gameInit")) {
	show_debug_message("Initialising...");
	
	// ===== Global Variables =====
	show_debug_message("Generating Global Variables...");
	
	// Likely to change a lot
	global.previousRoom = room; /// @is {room}
	global.paused = false; /// @is {bool}
	global.switchingSections = false; /// @is {bool}
	
	// Unlikely to change that much, if at all
	global.osInfo = os_get_info(); /// @is {ds_map}
	
	// Not intended to be accessed outside of system-specific code
	global.__collisionList = ds_list_create(); /// @is {ds_list}
	
	// ===== Load Settings =====
	options_data().load_from_file();
	game_window().update_screen();
	game_window().center_window();
	
	// ===== Setup Some Debug Views =====
	options_data().debug_view();
	
	// ===== Finish =====
	show_debug_message("...Initialisation Finished");
	global.__gameInit = true;
}

// ===== Reset various global variables =====
global.paused = false;