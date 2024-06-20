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
	static stepBegin = function() {
		global.gameTimeScale.update();
    };
    
    static roomStart = function() {
		// Set some global variables
		global.roomName = room_get_name(room);
		global.roomIsLevel = asset_has_tags(global.roomName, "room_level");
		show_debug_message("{0} -- Instance Count: {1}, Is Level: {2}", global.roomName, instance_count, global.roomIsLevel);
		
        // Setup the view
        view_enabled = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], GAME_WIDTH, GAME_HEIGHT);
        camera_set_update_script(view_camera[0], __camera_sync_to_game_view);
        view_set_wport(0, GAME_WIDTH);
        view_set_hport(0, GAME_HEIGHT);
        game_view().reset_all();
        
        // Recalibrate the game speed (incase someone decided to change it)
        game_set_speed(GAME_SPEED, gamespeed_fps);
    };
    
    static roomEnd = function() {
        
    };
    
    static drawEnd = function() {
		if (options_data().showFPS) {
			draw_set_text_align(fa_right, fa_bottom);
			draw_text(game_view().right_edge(), game_view().bottom_edge(), fps);
			draw_reset_text_align();
		}
    };
}

/// @func Subsystem_Camera()
/// @desc Manages the in-game camera
function Subsystem_Camera() : Subsystem() constructor {
	active = false;
	
	static stepEnd = function() {
		var _gameView = game_view();
		_gameView.reset_offset();
		
        if (!active)
            return;
        
        // TO-DO-BETTER: 
        var _camX = 0,
            _camY = 0;
		var _count = 0;
		var _pixelPerfect = options_data().pixelPerfect;
		
		with (prtPlayer) {
            _camX += x + subPixelX * !_pixelPerfect;
            _camY += y + subPixelY * !_pixelPerfect;
            _count++;
        }
        
        if (_count > 0) {
            _camX = (_camX / _count) - GAME_WIDTH * 0.5;
            _camY = (_camY / _count) - GAME_HEIGHT * 0.5;
        } else {
            _camX = _gameView.xView;
            _camY = _gameView.yView;
        }
        
        var _boundsLeft = 0,
			_boundsTop = 0,
			_boundsRight = room_width,
			_boundsBottom = room_height;
        _camX = clamp(_camX, _boundsLeft, _boundsRight - GAME_WIDTH);
        _camY = clamp(_camY, _boundsTop, _boundsBottom - GAME_HEIGHT);
        
        _gameView.set_prev_position(_gameView.xView, _gameView.yView);
        _gameView.set_position(_camX, _camY);
    };
    
    static roomStart = function() {
		active = false; // Most non-level rooms do not need the camera to be active
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
			
			if (keyboard_check_pressed(vk_f6)) {
				var _newFPS = (game_get_speed(gamespeed_fps) == 60 ? 1 : 60);
				game_set_speed(_newFPS, gamespeed_fps);
			}
			
			if (keyboard_check_pressed(vk_f7)) {
				freeRoamEnabled = !freeRoamEnabled;
				
				if (freeRoamEnabled) {
					freeRoamX = game_view().xView;
					freeRoamY = game_view().yView;
					camera_set_begin_script(view_camera[0], __camera_debug_free_roam);
				} else {
					camera_set_begin_script(view_camera[0], -1);
				}
			}
			
			if (keyboard_check_pressed(vk_f8) && global.roomIsLevel) {
				var _layers = [LAYER_COLLISION, LAYER_SECTION, LAYER_SECTION_GRID, LAYER_TRANSITION];
				array_foreach(_layers, function(_layer, i) /*=>*/ { layer_set_visible(layer_get_id(_layer), !layer_get_visible(_layer)); });
			}
        }
    };
    
    static stepEnd = function() {
        if (freeRoamEnabled) {
			freeRoamX += 2 * (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4));
			freeRoamY += 2 * (keyboard_check(vk_numpad2) - keyboard_check(vk_numpad8));
        }
    };
    
    static drawEnd = function() {
        if (freeRoamEnabled) {
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_set_colour(c_green);
			
			var _gameView = game_view();
			draw_rectangle_width(_gameView.left_edge(0), _gameView.top_edge(0), _gameView.right_edge(0), _gameView.bottom_edge(0), 4);
			draw_text(freeRoamX + GAME_WIDTH * 0.5, freeRoamY + GAME_HEIGHT * 0.5, "BOUNDARY BREAK");
			
			draw_reset_text_align();
			draw_reset_colour();
        }
    };
}

/// @func Subsystem_Flasher()
/// @desc Manages in-game screen flash
///		  NOTE: Don't overuse. Some people are photosensitive
function Subsystem_Flasher() : Subsystem() constructor {
	colour = c_white;
	timer = 0;
	
	static stepEnd = function() {
		if (timer <= 0 || global.paused)
			return;
		
		timer = approach(timer, 0, global.gameTimeScale.integer);
		if (timer == 0)
			colour = c_white;
	};
	
	static roomStart = function() {
		timer = 0;
		colour = c_white;
	};
	
	static drawEnd = function() {
		if (timer > 0 && !global.paused) {
			var _gameView = game_view();
			draw_sprite_ext(sprDot, 0, _gameView.get_x(), _gameView.get_y(), GAME_WIDTH, GAME_HEIGHT, 0, colour, 1);
		}
    };
}

/// @func Subsystem_Level()
/// @desc Handles level-specific actions, such as drawing a HUD
function Subsystem_Level() : Subsystem() constructor {
	active = false;
    canPause = true;
    data = {}; // Data specific to the current level
    
    static roomStart = function() {
		active = global.roomIsLevel;
		if (!active)
			return;
		
		assert(instance_exists(objDefaultSpawn), "Began a stage but nowhere for player to spawn.");
		
		// Calculate spawn coordinates
		// (Will be more elaborate once I add checkpoints & teleporting)
		var _spawn_x = objDefaultSpawn.x,
			_spawn_y = objDefaultSpawn.y;
		var _body = spawn_player_character(_spawn_x, _spawn_y, LAYER_ENTITY, CharacterType.MEGA);
		global.player.set_body(_body);
		
		system.camera.active = true;
		system.camera.stepEnd();
		
		var _layers = [LAYER_COLLISION, LAYER_SECTION, LAYER_SECTION_GRID, LAYER_TRANSITION];
		array_foreach(_layers, function(_layer, i) /*=>*/ { layer_set_visible(layer_get_id(_layer), false); });
		
		data = {};
    };
}

/// @func Subsystem_Input()
/// @desc Manages player input
function Subsystem_Input() : Subsystem() constructor {
	reader = new InputReader();
	
	static stepBegin = function() {
		var _inputs = global.player.inputs,
			_prev_held = _inputs.held,
			_non_helds = 0;
		
		reader.update();
		_inputs.clear_all();
		_inputs.held = reader.results;
		_non_helds = (_prev_held ^ _inputs.held);
		_inputs.pressed = (_non_helds & _inputs.held);
		_inputs.released = (_non_helds & _prev_held);
    };
    
    static asyncSystem = function() {
        switch (async_load[? "event_type"]) {
            case "gamepad discovered":
                reader.controller = async_load[? "pad_index"];
                break;
            
            case "gamepad lost":
                if (reader.controller == async_load[? "pad_index"])
                    reader.controller = NO_CONTROLLER;
                break;
        }
    }
}

/// @func Subsystem_Shaker()
/// @desc Manages in-game screen shakes
function Subsystem_Shaker() : Subsystem() constructor {
	strengthX = 0;
	strengthY = 0;
	timer = 0;
	
	__shakeX = 0;
	__shakeY = 0;
	
	static stepEnd = function() {
		if (timer <= 0 || global.paused)
			return;
		
		var _gameTicks = global.gameTimeScale.integer;
		if (_gameTicks >= 1) {
			timer = approach(timer, 0, _gameTicks);
			if (timer == 0) {
				strengthX = 0;
				strengthY = 0;
			}
			__shakeX = choose(-strengthX, 0, strengthX);
			__shakeY = choose(-strengthY, 0, strengthY);
		}
		
		game_view().add_offset(__shakeX, __shakeY);
	};
	
	static roomStart = function() {
		strengthX = 0;
		strengthY = 0;
		timer = 0;
		__shakeX = 0;
		__shakeY = 0;
	};
};
