#region Menu

function OptionsMenu() : UIFramework_Menu() constructor {
	nextSubmenu = undefined;
    
    /// @method switch_to_submenu(submenu_id)
    static switch_to_submenu = function(_submenuID) {
		nextSubmenu = get_submenu(_submenuID);
		owner.phase = 10;
		owner.phaseTimer = 0;
		play_sfx(sfxMenuSelect);
    };
}

#endregion

#region Submenu (only one type needed)

function OptionsMenu_Submenu(_id, _header) : UIFramework_Submenu(_id) constructor {
	header = _header;
	
	/// @method on_focus_enter()
	static on_focus_enter = function() {
		if (id == "main" && !is_undefined(menu.previousSubmenu))
			defaultItem = previousItem;
	}
	
	/// @method on_render(x, y)
    static on_render = function(_x, _y) {
		draw_set_valign(fa_top);
		
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 16 + 8 * (i == 0);
			i++;
		}
    };
    
    /// @method refresh_item_values()
    static refresh_item_values = function() {
		var i = 0;
		repeat(itemCount) {
			items[i].refresh_value();
			i++;
		}
    };
}

#endregion

#region Items

function OptionsMenu_Item(_id, _label) : UIFramework_Item(_id) constructor {
    label = _label;
    value = "";
    
    /// @method on_render(x, y)
	/// @desc Renders this item
    static on_render = function(_x, _y) {
		draw_set_colour(is_focused() ? c_yellow : c_white);
		draw_set_halign(fa_left);
		draw_text(_x - 96, _y, label);
		draw_set_halign(fa_right);
		draw_text(_x + 96, _y, value);
    };
    
    /// @method refresh_value()
    static refresh_value = function() {
		//...
    };
}

function OptionsMenu_Item_ControlBinding(_isKeyboard) : OptionsMenu_Item($"bindings_{_isKeyboard ? "keyboard" : "gamepad"}", $"BINDINGS ({_isKeyboard ? "KEYBOARD" : "GAMEPAD"})") constructor {
	__isKeyboard = _isKeyboard;
	
	/// @method on_confirm()
	static on_confirm = function() {
        if (!__isKeyboard && !objSystem.input.reader.has_controller()) {
            play_sfx(sfxError);
            return;
        }
        
        var _gameView = game_view();
        instance_create_depth(_gameView.center_x(), _gameView.center_y(), owner.depth - 1, objControlsRebinder, { isBindingKeyboard: __isKeyboard });
        owner.phase = 20;
    };
}

function OptionsMenu_Item_GameSpeed() : OptionsMenu_Item("gamespeed", "GAME SPEED") constructor {
	static on_x_dir = function(_dir) {
		var _newSpeed = (options_data().gameSpeed == 1) ? 50/60 : 1;
        options_data().gameSpeed = _newSpeed;
        refresh_value();
        play_sfx(sfxMenuMove);
	};
	
	/// @method refresh_value()
    static refresh_value = function() {
		value = (options_data().gameSpeed == 1) ? "NTSC" : "PAL";
    };
}

function OptionsMenu_Item_ScreenSize() : OptionsMenu_Item("screensize", "SCREEN SIZE") constructor {
	static on_x_dir = function(_dir) {
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
	
	/// @method refresh_value()
    static refresh_value = function() {
		value = string(options_data().screenSize);
    };
}

function OptionsMenu_Item_Slider(_id, _label) : OptionsMenu_Item(_id, _label) constructor {
	static on_x_dir = function(_dir) {
		var _prevVolume = options_data()[$ id],
            _newVolume = clamp(_prevVolume + 0.1 * _dir, 0, 1);
        options_data()[$ id] = round_to(_newVolume, 0.1);
        
        if (_newVolume != _prevVolume) {
			self.refresh_value();
			play_sfx(sfxMenuMove);
			
			if (id != "volumeSound")
				self.update_music_volume();
        }
	};
	
	/// @method refresh_value()
    static refresh_value = function() {
		value = floor(options_data()[$ id] * 100);
    };
    
    static update_music_volume = function() {
		with (objSystem.music) {
			if (!is_undefined(track))
				audio_sound_gain(track, options_data().get_music_volume(), 0);
		}
    };
}

function OptionsMenu_Item_SwitchSubmenu(_label, _submenuID) : OptionsMenu_Item("back", _label) constructor {
	__submenuID = _submenuID;
	
	/// @method on_confirm()
	static on_confirm = function() {
		if (!is_undefined(__submenuID)) {
			menu.switch_to_submenu(__submenuID);
			return;
		}
		
		// No subbmenu assigned? Let's leave the Options Menu then.
		play_sfx(sfxMenuSelect);
		if (room == rmOptions) {
			go_to_room(rmTitleScreen);
		} else {
			screen_fade({
				onFadeOutEnd: function() /*=>*/ { instance_destroy(owner); },
				fadeOutDuration: 10,
				fadeHoldDuration: 1,
				fadeInDuration: 10
			});
		}
	};
}

function OptionsMenu_Item_Toggle(_id, _label, _updateScreen = false, _toggleValues = ["OFF", "ON"]) : OptionsMenu_Item(_id, _label) constructor {
	__toggleValues = _toggleValues;
	__updateScreen = _updateScreen;
	
	static on_x_dir = function(__) {
		var _optionsData = options_data();
		
		_optionsData[$ id] = !_optionsData[$ id];
        refresh_value();
        play_sfx(sfxMenuMove);
        
        if (__updateScreen)
			game_window().update_screen();
		
		if (id == "autoFire" || id == "chargeToggle") {
			if (_optionsData.autoFire && !_optionsData.chargeToggle) {
				_optionsData.chargeToggle |= (id == "autoFire");
				_optionsData.autoFire &= ~(id == "chargeToggle");
				submenu.get_item("autoFire").refresh_value();
				submenu.get_item("chargeToggle").refresh_value();
			}
		}
	};
	
	static refresh_value = function() {
		value = __toggleValues[bool(options_data()[$ id])];
	};
}

#endregion
