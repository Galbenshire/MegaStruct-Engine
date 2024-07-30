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
		with (global.gameTimeScale) {
			value = options_data().gameSpeed;
			update();
		}
		global.roomTimer++;
		global.systemTimer++;
    };
    
    static roomStart = function() {
		// Set some global variables
		global.roomName = room_get_name(room);
		global.roomIsLevel = is_room_level(room);
		global.section = noone;
        global.roomTimer = 0;
		
        // Setup the view
        view_enabled = true;
        view_visible[0] = true;
        camera_set_view_size(view_camera[0], GAME_WIDTH, GAME_HEIGHT);
        camera_set_update_script(view_camera[0], __camera_sync_to_game_view);
        view_set_wport(0, GAME_WIDTH);
        view_set_hport(0, GAME_HEIGHT);
        game_view().reset_all();
        
        // Misc. Stuff
        
        game_set_speed(GAME_SPEED, gamespeed_fps);
        queue_unpause();
        signal_bus().prune_all_signals();
        show_debug_message("{0} -- Instance Count: {1}, Is Level: {2}", global.roomName, instance_count, global.roomIsLevel);
    };
    
    static roomEnd = function() {
        global.player.lockpool.remove_all_switches();
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
			if (entity_is_dead() || ignoreCamera)
				continue;
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
        
        var _section = global.section,
			_sectionExists = instance_exists(_section);
		var _boundsLeft = _sectionExists ? _section.left : 0,
			_boundsTop = _sectionExists ? _section.top : 0,
			_boundsRight = _sectionExists ? _section.right : room_width,
			_boundsBottom = _sectionExists ? _section.bottom : room_height;
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
    
    // Since checkpoints can get destroyed mid-game,
    // we need to store a list here
    checkpointList = [];
    
    instanceCountActive = 0;
    instanceCountRoomStart = 0;
    instanceListNames = "---- Objects ----";
	instanceListCounts = "---- Counts ----";
	
	consoleLog = [];
	consoleLogCount = 0;
    
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
                print(string("Screen Scale: {0}", screenSize));
                _updateScreen = true;
                _recenterScreen = true;
            }
            if (keyboard_check_pressed(vk_f3)) {
                set_fullscreen(!fullscreen);
                print(string("Fullscreen: {0}", fullscreen ? "ON" : "OFF"));
                _updateScreen = true;
                _recenterScreen |= !fullscreen;
            }
            if (keyboard_check_pressed(vk_f4)) {
                set_pixel_perfect(!pixelPerfect);
                print(string("Pixel Perfect: {0}", pixelPerfect ? "ON" : "OFF"));
                _updateScreen = true;
            }
            
            if (_updateScreen)
                game_window().update_screen();
            if (_recenterScreen)
                game_window().center_window();
        }
        
        // Screenshot
        if (keyboard_check_pressed(vk_f10)) {
			var _depth = layer_get_depth(LAYER_SYSTEM) - 10,
				_screenshotFile = "",
				_screenshotID = -1;
			
			do {
				_screenshotID++;
				_screenshotFile = string("{0}\screenshots\\screenshot_{1}.png", working_directory, _screenshotID);
			} until(!file_exists(_screenshotFile));
			
			var _defer = defer(DeferType.DRAW_GUI_END, function (__) { 
				screen_save(screenshotFile);
				print("SCREENSHOT SAVED", 0, c_orange, true);
				show_debug_message("Saved screenshot at {0}", screenshotFile);
				play_sfx(sfxBolt);
			}, 0, true, true);
			_defer.depth = layer_get_depth(LAYER_SYSTEM) - 10;
			_defer.screenshotFile = _screenshotFile;
        }
        
        // Debug Exclusive Operations
        if (DEBUG_ENABLED) {
			if (keyboard_check_pressed(vk_f5))
				show_debug_overlay(!is_debug_overlay_open());
			
			if (keyboard_check_pressed(vk_f6)) {
				if (game_get_speed(gamespeed_fps) != 60) {
					game_set_speed(60, gamespeed_fps);
				} else {
					var _newFPS = keyboard_check(vk_shift) ? 1 : 5;
					game_set_speed(_newFPS, gamespeed_fps);
				}
			}
			
			if (keyboard_check_pressed(vk_f7)) {
				if (freeRoamEnabled) {
					freeRoamEnabled = false;
					camera_set_begin_script(view_camera[0], -1);
				} else if (keyboard_check(vk_shift)) {
					if (global.roomIsLevel && !instance_exists(objMapper))
						instance_create_layer(0, 0, LAYER_SYSTEM, objMapper);
				} else if (!instance_exists(objMapper)) {
					freeRoamEnabled = true;
					freeRoamX = game_view().xView;
					freeRoamY = game_view().yView;
					camera_set_begin_script(view_camera[0], __camera_debug_free_roam);
				}
			}
			
			if (global.roomIsLevel) {
				if (keyboard_check_pressed(vk_f8)) {
					var _layers = [LAYER_COLLISION, LAYER_SECTION, LAYER_SECTION_GRID , LAYER_TRANSITION];
					array_foreach(_layers, function(_layer, i) /*=>*/ { layer_set_visible(layer_get_id(_layer), !layer_get_visible(_layer)); });
				}
				
				if (keyboard_check_pressed(vk_f9)) {
					with (global.player) {
						if (!instance_exists(body))
							break;
						if (body.isIntro)
							break;
						
						if (body.isFreeMovement)
							body.stateMachine.change("Idle");
						else
							body.stateMachine.change("Debug_FreeMovement");
					}
				}
			}
        }
    };
    
    static stepEnd = function() {
		if (DEBUG_ENABLED)
			instanceCountActive = instance_count;
		
        if (freeRoamEnabled) {
			freeRoamX += 2 * (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4));
			freeRoamY += 2 * (keyboard_check(vk_numpad2) - keyboard_check(vk_numpad8));
        }
        
        var _consoleCount = consoleLogCount,
			i = _consoleCount - 1;
		repeat(_consoleCount) {
			var _line = consoleLog[i];
			
			_line[ConsoleLine.lifetime]--;
			
			if (_line[ConsoleLine.lifetime] <= 0) {
				_line[ConsoleLine.alpha] -= 1/60;
				
				if (_line[ConsoleLine.alpha] <= 0) {
					array_delete(consoleLog, i, 1);
					consoleLogCount--;
				}
			}
			
			i--;
		}
    };
    
    static roomStart = function() {
		if (DEBUG_ENABLED) {
			instanceCountActive = instance_count;
			instanceCountRoomStart = instance_count;
			instanceListNames = "---- Objects ----";
			instanceListCounts = "---- Counts ----";
			
			if (global.roomIsLevel) {
				checkpointList = [];
				with (objDefaultSpawn)
					array_push(other.checkpointList, checkpointData);
				with (objCheckpoint)
					array_push(other.checkpointList, data);
			}
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
    
    static drawGUI = function() {
		draw_set_text_align(fa_left, fa_bottom);
		
		var _consoleX = 0,
			_consoleY = window_get_height(),
			_consoleCount = consoleLogCount,
			i = _consoleCount - 1;
		
		repeat(_consoleCount) {
			var _line = consoleLog[i],
				_text = _line[ConsoleLine.text],
				_colour = _line[ConsoleLine.colour],
				_alpha = _line[ConsoleLine.alpha];
			draw_text_colour(_consoleX, _consoleY, _text, _colour, _colour, _colour, _colour, _alpha);
			
			_consoleY -= 10;
			i--;
		}
		
		draw_reset_text_align();
    }
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

/// @func Subsystem_HUD()
/// @desc Handles the drawing of a HUD
function Subsystem_HUD() : Subsystem() constructor {
	active = false;
	playerHUD = undefined; /// @is {PlayerHUD}
	bossHUD = [];
	
	static roomStart = function() {
		active = global.roomIsLevel;
		if (active) {
			playerHUD = global.player.hudElement;
			bossHUD = [];
		}
	};
	
	static draw = function() {
        if (!active)
            return;
        
        var _hudX = game_view().left_edge(8),
			_hudY = game_view().top_edge(8),
			_bossCount = array_length(bossHUD);
		
        playerHUD.draw(_hudX, _hudY);
        for (var i = 0; i < _bossCount; i++)
			bossHUD[i].draw(_hudX + 24, _hudY);
		
		_hudX = game_view().right_edge(-8);
		draw_set_text_align(fa_right, fa_top);
		draw_text(_hudX, _hudY, string("Bolts: {0}", global.bolts));
		draw_reset_text_align();
    };
}

/// @func Subsystem_Level()
/// @desc Handles level-specific actions
function Subsystem_Level() : Subsystem() constructor {
	active = false;
	pauseStack = new LockStack();
    data = {}; // Data specific to the current level
    pickups = [];
    checkpoint = array_create(CheckpointData.sizeof); /// @is {CheckpointData}
    
    __startLevel = false; // flag to know when we're starting a level
    
    static stepEnd = function() {
		if (!active || pauseStack.is_locked() || global.paused || global.switchingSections)
			return;
		
		with (global.player) {
			if (inputs.is_pressed(InputActions.PAUSE)) {
				var _menu = instance_create_layer(0, 0, LAYER_FADER, objPauseMenu);
				_menu.depth += 5;
			}
		}
    };
    
    static roomStart = function() {
		active = global.roomIsLevel;
		if (!active)
			return;
		
		assert(instance_exists(objSection), "Stage contains no sections. Please use objSection to define them.");
		
		if (__startLevel) {
			assert(instance_exists(objDefaultSpawn), "Began a stage but nowhere for player to spawn.");
			checkpoint = variable_clone(objDefaultSpawn.checkpointData);
			data = {};
			pickups = [];
		}
		
		var _spawnX = checkpoint[CheckpointData.x],
			_spawnY = checkpoint[CheckpointData.y],
			_spawnDir = checkpoint[CheckpointData.dir];
		
		global.section = find_section_at(_spawnX, _spawnY);
		assert(global.section != noone, "Spawn coordinates are outside of any defined section");
		
		if (!array_empty(pickups)) {
			with (prtPickup) {
				if (array_contains(other.pickups, pickupID))
					instance_destroy();
			}
		}
		
		var _player = global.player;
		with (spawn_player_entity(_spawnX, _spawnY, LAYER_ENTITY, _player.character)) {
			image_xscale = _spawnDir;
			_player.set_body(self);
			_player.generate_loadout();
			_player.hudElement.healthpoints = healthpoints;
			player_equip_weapon(0);
			player_refresh_palette();
		}
		
		system.camera.active = true;
		system.camera.stepEnd(); // Get the camera to focus on the player
		
		var _layers = [LAYER_COLLISION, LAYER_SECTION, LAYER_SECTION_GRID, LAYER_TRANSITION];
		array_foreach(_layers, function(_layer, i) /*=>*/ { layer_set_visible(layer_get_id(_layer), false); });
		
		defer(DeferType.STEP_BEGIN, function() {
			deactivate_game_objects(false);
			activate_game_objects();
		}, 0, true, true);
		
		// The default level start sequence
		// (might offer an option in the future to override this)
		var _ready = instance_create_depth(0, 0, system.depth + 1, objReady);
		_ready.text = string("READY\n{0}", __startLevel ? "(stage start)" : "(checkpoint)");
		with (prtPlayer) {
			if (is_player_controlled()) {
				stateMachine.change("StageStart");
				signal_bus().connect_to_signal("readyComplete", self, function(_data) /*=>*/ { stateMachine.change("Intro"); }, true);
			}
		}
		
		__startLevel = false;
    };
    
    static roomEnd = function() {
		pauseStack.remove_all_switches();
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

/// @func Subsystem_Pause()
/// @desc Manages the pausing of the game
function Subsystem_Pause() : Subsystem() constructor {
	pauseQueue = 0;
	__pauseCache = false;
	
	static stepBegin = function() {
		assert(global.paused == __pauseCache, "global.paused was modified directly. Use queue_pause() or queue_unpause() instead.");
		
		if (pauseQueue == 0)
			return;
		
		switch (pauseQueue) {
			case QUEUED_PAUSE:
				global.paused = true;
				time_source_pause(time_source_game);
				break;
			
			case QUEUED_UNPAUSE:
				global.paused = false;
				time_source_resume(time_source_game);
				break;
			
			default:
				assert(false, string("pauseQueue set to an invalid value: {0}", pauseQueue));
				break;
		}
		
		__pauseCache = global.paused;
		pauseQueue = 0;
	};
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
