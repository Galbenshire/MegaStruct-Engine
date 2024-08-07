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

function OptionsMenu_Submenu(_id, _header) : UIFramework_Submenu(_id) constructor {
	header = _header;
    
    /// @method refresh_item_values()
    static refresh_item_values = function() {
		var i = 0;
		repeat(itemCount) {
			items[i].refresh_value();
			i++;
		}
    };
    
    /// @method render(x, y)
    static render = function(_x, _y) {
		draw_set_valign(fa_top);
		
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 16 + 8 * (i == 0);
			i++;
		}
    };
}

function OptionsMenu_Item(_id, _label) : UIFramework_Item(_id) constructor {
    label = _label;
    
    value = "";
    onRefreshValue = undefined;
    
    /// @method refresh_value()
    static refresh_value = function() {
		if (!is_undefined(onRefreshValue))
			value = onRefreshValue();
    };
    
    /// @method render(x, y)
	/// @desc Renders this item
    static render = function(_x, _y) {
		draw_set_colour(is_focused() ? c_yellow : c_white);
		draw_set_halign(fa_left);
		draw_text(_x - 96, _y, label);
		draw_set_halign(fa_right);
		draw_text(_x + 96, _y, value);
    };
}

function OptionsMenu_Item_SwitchSubmenu(_label, _submenuID) : OptionsMenu_Item("back", _label) constructor {
	__submenuID = _submenuID;
	onConfirm = function() /*=>*/ { menu.switch_to_submenu(__submenuID); };
}

function OptionsMenu_Item_ControlBinding(_isKeyboard) : OptionsMenu_Item($"bindings_{_isKeyboard ? "keyboard" : "gamepad"}", $"BINDINGS ({_isKeyboard ? "KEYBOARD" : "GAMEPAD"})") constructor {
	__isKeyboard = _isKeyboard;
	onConfirm = function() {
        if (!__isKeyboard && !objSystem.input.reader.has_controller()) {
            play_sfx(sfxError);
            return;
        }
        
        var _gameView = game_view();
        instance_create_depth(_gameView.center_x(), _gameView.center_y(), owner.depth - 1, objControlsRebinder, { isBindingKeyboard: __isKeyboard });
        owner.phase = 20;
    };
}

function OptionsMenu_Item_Toggle(_id, _label, _updateScreen = false, _toggleValues = ["OFF", "ON"]) : OptionsMenu_Item(_id, _label) constructor {
	__toggleValues = _toggleValues;
	__updateScreen = _updateScreen;
	
	onRefreshValue = function() /*=>*/ {return __toggleValues[bool(options_data()[$ id])]};
	onXDir = function(__) {
		with (options_data())
			self[$ other.id] = !self[$ other.id];
        refresh_value();
        play_sfx(sfxMenuMove);
        
        if (__updateScreen)
			game_window().update_screen();
    };
}

function OptionsMenu_Item_Slider(_id, _label) : OptionsMenu_Item(_id, _label) constructor {
	onRefreshValue = function() /*=>*/ {return floor(options_data()[$ id] * 100)};
	onXDir = function(_dir) {
        with (options_data()) {
            var _prevVolume = self[$ other.id],
                _newVolume = clamp(_prevVolume + 0.1 * _dir, 0, 1);
            self[$ other.id] = round_to(_newVolume, 0.1);
            
            if (_newVolume != _prevVolume) {
                other.refresh_value();
                play_sfx(sfxMenuMove);
            }
        }
    };
}
