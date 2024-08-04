/// @description Init Menu
#region Main

with (menu.add_submenu("main", "OPTIONS")) {
    with (add_item("back", "LEAVE")) {
        submenu.defaultItem = self;
        onConfirm = function() /*=>*/ { go_to_room(rmTitleScreen); };
    }
    with (add_item("controls", "CONTROLS"))
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.controls); };
    with (add_item("display", "DISPLAY"))
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.display); };
    with (add_item("audio", "AUDIO"))
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.audio); };
    with (add_item("misc", "OTHER"))
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.misc); };
    
    onFocusEnter = function() {
        if (!is_undefined(menu.previousSubmenu))
            defaultItem = previousItem;
    };
    
    generate_neighbours();
    refresh_item_values();
}

#endregion

#region Controls

with (menu.add_submenu("controls", "CONTROLS")) {
    with (add_item("back", "BACK")) {
        submenu.defaultItem = self;
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.main); };
    }
    with (add_item("bindings_keyboard", "BINDINGS (KEYBOARD)")) {
        onConfirm = function() {
            var _gameView = game_view();
            instance_create_depth(_gameView.center_x(), _gameView.center_y(), owner.depth - 1, objControlsRebinder, { isBindingKeyboard: true });
            owner.phase = 20;
        };
    }
    with (add_item("bindings_gamepad", "BINDINGS (GAMEPAD)")) {
        onConfirm = function() {
            if (!objSystem.input.reader.has_controller()) {
                play_sfx(sfxError);
                return;
            }
            
            var _gameView = game_view();
            instance_create_depth(_gameView.center_x(), _gameView.center_y(), owner.depth - 1, objControlsRebinder, { isBindingKeyboard: false });
            owner.phase = 20;
        };
    }
    with (add_item("downjump", "DOWN+JUMP")) {
        onRefreshValue = function() /*=>*/ {return options_data().downJumpSlide ? "SLIDE" : "NONE"};
        onXDir = function(__) {
            options_data().downJumpSlide = !options_data().downJumpSlide;
            refresh_value();
            play_sfx(sfxMenuMove);
        };
    }
    with (add_item("autofire", "AUTO FIRE")) {
        onRefreshValue = function() /*=>*/ {return options_data().autoFire ? "ON" : "OFF"};
        onXDir = function(__) {
            var _optionsData = options_data();
            
            _optionsData.autoFire = !_optionsData.autoFire;
            refresh_value();
            play_sfx(sfxMenuMove);
            
            if (_optionsData.autoFire && !_optionsData.chargeToggle) {
                _optionsData.chargeToggle = true;
                submenu.items.chargetoggle.refresh_value();
            }
        };
    }
    with (add_item("chargetoggle", "CHARGE TOGGLE")) {
        onRefreshValue = function() /*=>*/ {return options_data().chargeToggle ? "ON" : "OFF"};
        onXDir = function(__) {
            var _optionsData = options_data();
            
            _optionsData.chargeToggle = !_optionsData.chargeToggle;
            refresh_value();
            play_sfx(sfxMenuMove);
            
            if (!_optionsData.chargeToggle && _optionsData.autoFire) {
                _optionsData.autoFire = false;
                submenu.items.autofire.refresh_value();
            }
        };
    }
    
    generate_neighbours();
    refresh_item_values();
}

#endregion

#region Display

with (menu.add_submenu("display", "DISPLAY")) {
    with (add_item("back", "BACK")) {
        submenu.defaultItem = self;
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.main); };
    }
    with (add_item("fullscreen", "FULLSCREEN")) {
        onRefreshValue = function() /*=>*/ {return options_data().fullscreen ? "ON" : "OFF"};
        onXDir = function(__) {
            options_data().fullscreen = !options_data().fullscreen;
            refresh_value();
            play_sfx(sfxMenuMove);
            
            game_window().update_screen();
        };
    }
    with (add_item("screensize", "SCREEN SIZE")) {
        onRefreshValue = function() /*=>*/ {return string(options_data().screenSize)};
        onXDir = function(_dir) {
            with (options_data()) {
                var _prevSize = screenSize;
                set_screen_size(screenSize + _dir);
                
                if (screenSize != _prevSize) {
                    other.refresh_value();
                    game_window().update_screen();
                    play_sfx(sfxMenuMove);
                }
            }
        };
    }
    with (add_item("pixelperfect", "PIXEL PERFECT")) {
        onRefreshValue = function() /*=>*/ {return options_data().pixelPerfect ? "ON" : "OFF"};
        onXDir = function(__) {
            options_data().set_pixel_perfect(!options_data().pixelPerfect);
            game_window().update_screen();
            play_sfx(sfxMenuMove);
            refresh_value();
        };
    }
    with (add_item("vsync", "VSYNC")) {
        onRefreshValue = function() /*=>*/ {return options_data().vsync ? "ON" : "OFF"};
        onXDir = function(__) {
            options_data().set_vsync(!options_data().vsync);
            game_window().update_screen();
            play_sfx(sfxMenuMove);
            refresh_value();
        };
    }
    with (add_item("fsp", "SHOW FPS")) {
        onRefreshValue = function() /*=>*/ {return options_data().showFPS ? "ON" : "OFF"};
        onXDir = function(__) {
            options_data().showFPS = !options_data().showFPS;
            game_window().update_screen();
            play_sfx(sfxMenuMove);
            refresh_value();
        };
    }
    
    generate_neighbours();
    refresh_item_values();
}

#endregion

#region Audio

with (menu.add_submenu("audio", "AUDIO")) {
    with (add_item("back", "BACK")) {
        submenu.defaultItem = self;
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.main); };
    }
    with (add_item("mastervolume", "MASTER VOLUME")) {
        onRefreshValue = function() /*=>*/ {return string(options_data().volumeMaster * 100)};
        onXDir = function(_dir) {
            with (options_data()) {
                var _prevVolume = volumeMaster * 100,
                    _newVolume = clamp(_prevVolume + 10 * _dir, 0, 100);
                set_master_volume(_newVolume);
                
                if (_newVolume != _prevVolume) {
                    other.refresh_value();
                    play_sfx(sfxMenuMove);
                }
            }
        };
    }
    with (add_item("musicvolume", "MUSIC VOLUME")) {
        onRefreshValue = function() /*=>*/ {return string(options_data().volumeMusic * 100)};
        onXDir = function(_dir) {
            with (options_data()) {
                var _prevVolume = volumeMusic * 100,
                    _newVolume = clamp(_prevVolume + 10 * _dir, 0, 100);
                set_music_volume(_newVolume);
                
                if (_newVolume != _prevVolume) {
                    other.refresh_value();
                    play_sfx(sfxMenuMove);
                }
            }
        };
    }
    with (add_item("musicvolume", "SOUND VOLUME")) {
        onRefreshValue = function() /*=>*/ {return string(options_data().volumeSound * 100)};
        onXDir = function(_dir) {
            with (options_data()) {
                var _prevVolume = volumeSound * 100,
                    _newVolume = clamp(_prevVolume + 10 * _dir, 0, 100);
                set_sound_volume(_newVolume);
                
                if (_newVolume != _prevVolume) {
                    other.refresh_value();
                    play_sfx(sfxMenuMove);
                }
            }
        };
    }
    
    generate_neighbours();
    refresh_item_values();
}

#endregion

#region Other

with (menu.add_submenu("misc", "OTHER")) {
    with (add_item("back", "BACK")) {
        submenu.defaultItem = self;
        onConfirm = function() /*=>*/ { menu.switch_to_submenu(menu.submenus.main); };
    }
    with (add_item("gamespeed", "GAME SPEED")) {
        onRefreshValue = function() /*=>*/ {return (options_data().gameSpeed == 1) ? "NTSC" : "PAL"};
        onXDir = function(__) {
            var _newSpeed = (options_data().gameSpeed == 1) ? 50/60 : 1;
            options_data().gameSpeed = _newSpeed;
            play_sfx(sfxMenuMove);
            refresh_value();
        };
    }
    with (add_item("chargebar", "CHARGE BAR")) {
        onRefreshValue = function() /*=>*/ {return options_data().chargeBar ? "ON" : "OFF"};
        onXDir = function(__) {
            options_data().chargeBar = !options_data().chargeBar;
            play_sfx(sfxMenuMove);
            refresh_value();
        };
    }
    
    generate_neighbours();
    refresh_item_values();
}

#endregion

with (menu) {
    defaultSubmenu = submenus.main;
    pass_submenu_focus(defaultSubmenu);
}