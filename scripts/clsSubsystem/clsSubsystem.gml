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
		global.sessionTimer++;
		global.systemTimer++;
		if (!global.paused)
			global.hitStunTimer = approach(global.hitStunTimer, 0, 1);
    };
    
    static roomStart = function() {
		// Set some global variables
		global.roomName = room_get_name(room);
		global.roomIsLevel = is_room_level(room);
		global.section = noone;
        global.roomTimer = 0;
        global.hitStunTimer = 0;
        global.pauseMenuActive = false;
		
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
        with (global.player) {
			lockpool.remove_all_switches();
			inputAccessLevel = PlayerInputLevel.MAIN;
		}
    };
    
    static drawEnd = function() {
		if (options_data().showFPS) {
			draw_set_text_align(fa_right, fa_bottom);
			draw_text(game_view().right_edge(), game_view().bottom_edge(), fps);
			draw_reset_text_align();
		}
    };
}

/// @func Subsystem_Audio()
/// @desc Manages the audio in this game, including the playing of music
function Subsystem_Audio() : Subsystem() constructor {
	// -- Variables
	track = undefined;
	trackID = 0;
	trackVolume = 0;
	
	emitterSFX = audio_emitter_create();
	emitterMusic = audio_emitter_create();
	
	// -- Events
	static roomEnd = function() {
		audio_stop_all();
		track = undefined;
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
		
		with (prtPlayer) {
			if (entity_is_dead() || ignoreCamera)
				continue;
            _camX += entity_x();
            _camY += entity_y();
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
	
	consoleWarningLevel = WarningLevel.ERROR;
	consoleLog = [];
	consoleLogCount = 0;
	
	stopwatchTimer = 0;
	stopwatchActive = false;
	
	flashDuration = 16;
	flashGain = 0;
	flashDecay = 0;
	flashStep = 0;
	flashCol = c_white;
	
	shakeDuration = 16;
	shakeStrengthX = 1;
	shakeStrengthY = 1;
	shakeDecay = 0;
    
    static stepBegin = function() {
        // Exit/Restart the game
        if (keyboard_check_pressed(vk_escape) && !is_browser()) {
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
			
			if (keyboard_check_pressed(vk_f2) && !fullscreen && !is_browser()) {
                var _newScale = screenSize + 1;
                self.set_screen_size(_newScale > MAX_SCALE ? 1 : _newScale);
                print($"Screen Scale: {screenSize}", WarningLevel.SHOW);
                _updateScreen = true;
                _recenterScreen = true;
            }
            if (keyboard_check_pressed(vk_f3) && !is_browser()) {
                self.set_fullscreen(!fullscreen);
                print($"Fullscreen: {fullscreen ? "ON" : "OFF"}", WarningLevel.SHOW);
                _updateScreen = true;
                _recenterScreen |= !fullscreen;
            }
            if (keyboard_check_pressed(vk_f4)) {
                self.set_pixel_perfect(!pixelPerfect);
                print($"Pixel Perfect: {pixelPerfect ? "ON" : "OFF"}", WarningLevel.SHOW);
                _updateScreen = true;
            }
            
            if (_updateScreen)
                game_window().update_screen();
            if (_recenterScreen)
                game_window().center_window();
        }
        
        // Screenshot
        if (keyboard_check_pressed(vk_f10)) {
			var _screenshotFile = "",
				_screenshotID = -1;
			
			do {
				_screenshotID++;
				_screenshotFile = string("{0}\screenshots\\screenshot_{1}.png", working_directory, _screenshotID);
			} until(!file_exists(_screenshotFile));
			
			var _defer = defer(DeferType.DRAW_GUI_END, function (__) { 
				screen_save(screenshotFile);
				print("SCREENSHOT SAVED", WarningLevel.SHOW, c_orange, true);
				show_debug_message($"Saved screenshot at {screenshotFile}");
				play_sfx(sfxBolt);
			}, 0, 0);
			_defer.depth = layer_get_depth(LAYER_SYSTEM) - 100;
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
				if (keyboard_check_pressed(vk_f8))
					construction_layers_set_visible(!layer_get_visible(LAYER_COLLISION));
				
				if (keyboard_check_pressed(vk_f9)) {
					with (global.player) {
						if (!instance_exists(body) || !player_is_active(body))
							break;
						
						if (keyboard_check(vk_shift))
							entity_kill_self(body);
						else
							body.stateMachine.change_state(body.isFreeMovement ? "StandardAir" : "Debug_FreeMovement");
					}
				}
			}
        }
    };
    
    static stepEnd = function() {
		if (DEBUG_ENABLED) {
			instanceCountActive = instance_count;
			
			if (freeRoamEnabled) {
				var _spd = 2 + 6 * keyboard_check(vk_numpad5);
				freeRoamX += _spd * (keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4));
				freeRoamY += _spd * (keyboard_check(vk_numpad2) - keyboard_check(vk_numpad8));
			}
			
			stopwatchTimer += stopwatchActive;
		}
        
        for (var i = consoleLogCount - 1; i >= 0; i--) {
			var _line = consoleLog[i];
			if (_line[ConsoleLine.lifetime]-- > 0)
				continue;
			
			_line[ConsoleLine.alpha] -= 1/60;
			if (_line[ConsoleLine.alpha] <= 0) {
				array_delete(consoleLog, i, 1);
				consoleLogCount--;
			}
        }
    };
    
    static roomStart = function() {
		if (DEBUG_ENABLED) {
			instanceCountActive = instance_count;
			instanceCountRoomStart = instance_count;
			instanceListNames = "---- Objects ----";
			instanceListCounts = "---- Counts ----";
			
			if (global.roomIsLevel) {
				array_clear(checkpointList);
				with (objDefaultSpawn)
					array_push(other.checkpointList, checkpointData);
				with (objCheckpoint)
					array_push(other.checkpointList, data);
			}
        }	
    };
    
    static drawEnd = function() {
        if (DEBUG_ENABLED && freeRoamEnabled) {
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_set_colour(c_green);
			
			var _gameView = game_view(),
				_edgeLeft = _gameView.left_edge(0),
				_edgeTop = _gameView.top_edge(0);
			
			draw_rectangle_outline(_edgeLeft, _edgeTop, GAME_WIDTH, GAME_HEIGHT, c_green, 1);
			draw_rectangle_outline(_edgeLeft - 1, _edgeTop - 1, GAME_WIDTH + 2, GAME_HEIGHT + 2, c_green, 1);
			draw_rectangle_outline(_edgeLeft + 1, _edgeTop + 1, GAME_WIDTH - 2, GAME_HEIGHT - 2, c_green, 0.5);
			draw_rectangle_outline(_edgeLeft - 2, _edgeTop - 2, GAME_WIDTH + 4, GAME_HEIGHT + 4, c_green, 0.5);
			draw_text(freeRoamX + GAME_WIDTH * 0.5, freeRoamY + GAME_HEIGHT * 0.5, "BOUNDARY BREAK");
			
			draw_reset_text_align();
			draw_reset_colour();
        }
    };
    
    static drawGUI = function() {
		draw_set_text_align(fa_left, fa_bottom);
		
		var _consoleX = 4,
			_consoleY = (os_type != os_gxgames) ? window_get_height() - 4 : (GAME_HEIGHT - 4) * options_data().screenSize,
			_consoleCount = consoleLogCount;
		
		var i = _consoleCount - 1; repeat(_consoleCount) {
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
	flashes = []; /// @is {array<ScreenFlashNote>}
	flashCount = 0;
	
	static process_flash_note = function(_note) {
		if (_note[ScreenFlashNote.isDone])
			return;
		
		// Fading in the flash
		if (_note[ScreenFlashNote.gain] > 0) {
			_note[ScreenFlashNote.alpha] = min(1, _note[ScreenFlashNote.alpha] + _note[ScreenFlashNote.gain]);
			_note[ScreenFlashNote.gain] *= (_note[ScreenFlashNote.alpha] < 1);
			return;
		}
		
		// Holding on the flash
		if (--_note[ScreenFlashNote.timer] > 0)
			return;
		
		// Fading out the flash
		var _decay = _note[ScreenFlashNote.decay];
		_note[ScreenFlashNote.alpha] = approach(_note[ScreenFlashNote.alpha], 0, _decay);
		_note[ScreenFlashNote.isDone] = (_note[ScreenFlashNote.alpha] == 0 || _decay <= 0);
	};
	
	static stepEnd = function() {
		if (flashCount <= 0 || global.paused)
			return;
		
		repeat(global.gameTimeScale.integer) {
			var i = flashCount - 1; repeat(flashCount) {
				var _flash = flashes[i];
				self.process_flash_note(_flash);
				
				if (_flash[ScreenFlashNote.isDone]) {
					array_delete(flashes, i, 1);
					flashCount--;
				}
				i--;
			}
			
			if (flashCount <= 0)
				break;
		}
	};
	
	static roomStart = function() {
		array_clear(flashes);
		flashCount = 0;
	};
	
	static drawEnd = function() {
		if (flashCount <= 0 || global.paused)
			return;
		
		var _gameView = game_view(),
			_xView = _gameView.get_x(),
			_yView = _gameView.get_y();
		
		var i = 0; repeat(flashCount) {
			var _flash = flashes[i],
				_alpha = _flash[ScreenFlashNote.alpha],
				_blend = _flash[ScreenFlashNote.colour],
				_step = _flash[ScreenFlashNote.step];
			
			if (_step > 0 && _alpha < 1)
				_alpha = round_to(_alpha, _step);
			
			draw_sprite_ext(sprDot, 0, _xView, _yView, GAME_WIDTH, GAME_HEIGHT, 0, _blend, _alpha);
			i++;
		}
    };
}

/// @func Subsystem_HUD()
/// @desc Handles the drawing of a HUD
function Subsystem_HUD() : Subsystem() constructor {
	active = false;
	bossHUD = []; /// @is {array<HUDElement_Boss>}
	
	static roomStart = function() {
		active = global.roomIsLevel;
		if (active)
			bossHUD = [];
	};
	
	static draw = function() {
        if (!active)
            return;
        
        var _hudX = game_view().left_edge(8),
			_hudY = game_view().top_edge(8),
			_playerHUD = global.player.hudElement;
		
		_playerHUD.draw(_hudX, _hudY);
		_hudX = game_view().right_edge(-16);
		
		var i = 0; repeat(array_length(bossHUD)) {
			_hudX -= bossHUD[i].get_width();
			bossHUD[i].draw(_hudX, _hudY);
			i++;
		}
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
				if (reader.controller == NO_CONTROLLER)
                	reader.controller = async_load[? "pad_index"];
                break;
            
            case "gamepad lost":
                if (reader.controller == async_load[? "pad_index"])
                    reader.controller = NO_CONTROLLER;
                break;
        }
    }
}

/// @func Subsystem_Level()
/// @desc Handles level-specific actions
function Subsystem_Level() : Subsystem() constructor {
	active = false;
	pauseStack = new LockStack();
    data = {}; // Data specific to the current level
    pickups = [];
    checkpoint = array_create(CheckpointData.sizeof); /// @is {CheckpointData}
    
    isStartingLevel = false; // flag to know when we're starting a level
    onLevelSpawn = method(undefined, self.level_spawn_standard);
    skipReady = false;
    spawnedPlayers = [];
    
    // The standard procedure for spawning into a level
    static level_spawn_standard = function() {
		if (!skipReady) {
			var _playWhistle = isStartingLevel && global.player.characterID == CharacterType.PROTO;
			instance_create_depth(0, 0, system.depth + 1, objReady, { playProtoWhistle: _playWhistle });
		}
		
		var i = 0; repeat(array_length(spawnedPlayers)) {
			with (spawnedPlayers[i]) {
				stateMachine.change_state("Inactive");
				
				if (other.skipReady) {
					defer(DeferType.STEP, function(_player) {
						if (is_screen_fading())
							return false;
						_player.teleport_in();
					});
				} else {
					signal_bus().connect_to_signal(SIGNAL_READY_COMPLETE, self, function(_data) /*=>*/ { self.teleport_in(); }, true);
				}
			}
			i++;
		}
    };
    
    // Version to level spawn-in that just plops the player in the level
    static level_spawn_quick = function() {
		var i = 0; repeat(array_length(spawnedPlayers)) {
			with (spawnedPlayers[i])
				self.teleport_in(TeleportInType.STAND);
			i++;
		}
    };
    
    static stepEnd = function() {
		if (!active || pauseStack.is_locked() || global.paused)
			return;
		
		with (global.player) {
			if (inputs.is_pressed(InputActions.PAUSE)) {
				var _menu = instance_create_layer(0, 0, LAYER_FADER, objPauseMenu);
				_menu.depth += 20;
			}
		}
    };
    
    static roomStart = function() {
		active = global.roomIsLevel;
		if (!active)
			return;
		
		assert(instance_exists(objSection), "Stage contains no sections. Please use objSection to define them.");
		
		if (isStartingLevel) {
			assert(instance_exists(objDefaultSpawn), "Began a stage but nowhere for player to spawn.");
			var _defaultSpawnList = instance_find_all(objDefaultSpawn);
			array_sort(_defaultSpawnList, function(_a, _b) /*=>*/ {return _b.priority - _a.priority});
			checkpoint = variable_clone(_defaultSpawnList[0].checkpointData);
		}
		
		var _spawnX = checkpoint[CheckpointData.x],
			_spawnY = checkpoint[CheckpointData.y],
			_spawnDir = checkpoint[CheckpointData.dir],
			_spawnAnim = checkpoint[CheckpointData.animation];
		
		global.section = find_section_at(_spawnX, _spawnY);
		assert(global.section != noone, "Spawn coordinates are outside of any defined section");
		
		if (!array_empty(pickups)) {
			with (prtPickup) {
				if (array_contains(other.pickups, pickupID))
					instance_destroy();
			}
		}
		
		global.player.set_body(spawn_player_entity(_spawnX, _spawnY, LAYER_ENTITY, global.player.characterID));
		with (global.player.body) {
			image_xscale = _spawnDir;
			hudElement.healthpoints = healthpoints;
			teleportInType = _spawnAnim;
			
			self.generate_weapons();
			self.equip_weapon(0);
			self.refresh_palette();
			
			array_push(other.spawnedPlayers, id);
		}
		
		system.camera.active = true;
		system.camera.stepEnd(); // Get the camera to focus on the player
		construction_layers_set_visible(false);
		
		defer(DeferType.STEP_BEGIN, function(__) {
			deactivate_game_objects(false);
			activate_game_objects();
		}, 0, 0);
		
		onLevelSpawn();
		isStartingLevel = false;
		skipReady = false;
		onLevelSpawn = method(undefined, self.level_spawn_standard);
		array_clear(spawnedPlayers);
    };
    
    static roomEnd = function() {
		pauseStack.remove_all_switches();
		
		if (isStartingLevel) {
			struct_remove_all(data);
			array_clear(pickups);
		}
    };
}

/// @func Subsystem_Pause()
/// @desc Manages the pausing of entites in the game
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
				assert(false, $"pauseQueue set to an invalid value: {pauseQueue}");
				break;
		}
		
		__pauseCache = global.paused;
		pauseQueue = 0;
	};
}

/// @func Subsystem_Shaker()
/// @desc Manages in-game screen shakes
function Subsystem_Shaker() : Subsystem() constructor {
	shakes = []; /// @is {array<ScreenShakeNote>}
	shakeCount = 0;
	
	__shakeX = 0;
	__shakeY = 0;
	
	static process_shake_note = function(_note) {
		if (--_note[ScreenShakeNote.timer] > 0 || _note[ScreenShakeNote.isDone])
			return;
		
		// Decay the strength of the shake
		var _decay = _note[ScreenShakeNote.decay];
		_note[ScreenShakeNote.strengthX] = approach(_note[ScreenShakeNote.strengthX], 0, _decay);
		_note[ScreenShakeNote.strengthY] = approach(_note[ScreenShakeNote.strengthY], 0, _decay);
		_note[ScreenShakeNote.isDone] = (_note[ScreenShakeNote.strengthX] == 0 && _note[ScreenShakeNote.strengthY] == 0) || _decay <= 0;
	};
	
	static stepEnd = function() {
		if (shakeCount <= 0 || global.paused)
			return;
		
		repeat(global.gameTimeScale.integer) {
			var _strengthX = 0,
				_strengthY = 0;
			
			var i = shakeCount - 1; repeat(shakeCount) {
				var _shake = shakes[i];
				self.process_shake_note(_shake);
				
				if (_shake[ScreenShakeNote.isDone]) {
					array_delete(shakes, i, 1);
					shakeCount--;
				} else {
					_strengthX = max(_strengthX, _shake[ScreenShakeNote.strengthX]);
					_strengthY = max(_strengthY, _shake[ScreenShakeNote.strengthY]);
				}
				
				i--;
			}
			
			__shakeX = choose(-_strengthX, 0, _strengthX);
			__shakeY = choose(-_strengthY, 0, _strengthY);
			
			if (shakeCount <= 0)
				break;
		}
		
		if (options_data().screenShake)
			game_view().add_offset(__shakeX, __shakeY);
	};
	
	static roomStart = function() {
		array_clear(shakes);
		shakeCount = 0;
		__shakeX = 0;
		__shakeY = 0;
	};
	
	static draw = function() {
        var _str = "";
		var i = 0; repeat(shakeCount) {
			var _shake = shakes[i];
			
			_str += $"{_shake}\n";
			i++;
		}
		
		draw_text_transformed(mouse_x, mouse_y, _str, 0.5, 0.5, 0);
    };
};
