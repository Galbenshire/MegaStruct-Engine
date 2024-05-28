/// @func Subsystem()
/// @desc Represents a subsystem of objSystem.
///       It's intended to categorized variabled & functions for better organization.
///       This base constructor should not be used itself, only its children.
function Subsystem() constructor {
    assert(other.object_index == objSystem, "A Subsystem should only be made for objSystem");
    
    system = other; /// @is {objSystem}
}

/// @func Subsystem_Core()
/// @desc Important operations of objSystem (or ones I could not find an actual category for)
function Subsystem_Core() : Subsystem() constructor {
    static roomStart = function() {
        // Setup the view
        view_enabled = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], GAME_WIDTH, GAME_HEIGHT);
        view_set_wport(0, GAME_WIDTH);
        view_set_hport(0, GAME_HEIGHT);
        
        // Recalibrate the game speed (incase someone decided to change it)
        game_set_speed(GAME_SPEED, gamespeed_fps);
    };
    
    static roomEnd = function() {
        
    };
    
    static drawEnd = function() {
		
    };
}

/// @func Subsystem_Debug()
/// @desc Manages debug operations
function Subsystem_Debug() : Subsystem() constructor {
    freeRoamEnabled = false;
    freeRoamX = 0;
    freeRoamY = 0;
    
    static stepBegin = function() {
        // Exit/Restart the game
        if (keyboard_check_pressed(vk_escape)) {
            game_end();
            return;
        }
        if (keyboard_check_pressed(vk_f1)) {
            game_restart();
            return;
        }
        
        // Screen Changing
        with (options_data()) {
            var _updateScreen = false,
                _recenterScreen = false;
			
			if (keyboard_check_pressed(vk_f2) && !fullscreen) {
                var _newScale = screenSize + 1;
                set_screen_size(_newScale > MAX_SCALE ? 1 : _newScale);
                _updateScreen = true;
                _recenterScreen = true;
            }
            if (keyboard_check_pressed(vk_f3)) {
                set_fullscreen(!fullscreen);
                _updateScreen = true;
                _recenterScreen |= !fullscreen;
            }
            if (keyboard_check_pressed(vk_f4)) {
                set_pixel_perfect(!pixelPerfect);
                _updateScreen = true;
            }
            
            if (_updateScreen)
                game_window().update_screen();
            if (_recenterScreen)
                game_window().center_window();
        }
        
        // Debug Exclusive Operations
        if (DEBUG_ENABLED) {
			if (keyboard_check_pressed(vk_f5))
				show_debug_overlay(!is_debug_overlay_open());
        }
    };
}
