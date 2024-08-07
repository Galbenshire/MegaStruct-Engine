/// @description Init Menu
#region Main

with (new OptionsMenu_Submenu("main", "OPTIONS")) {
	var _items = [];
	with (new OptionsMenu_Item("back", "LEAVE")) {
		onConfirm = function () {
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
			play_sfx(sfxMenuSelect);
		};
		array_push(_items, self);
	}
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("CONTROLS", "controls"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("DISPLAY", "display"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("AUDIO", "audio"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("OTHER", "misc"));
	
	onFocusEnter = function() {
        if (!is_undefined(menu.previousSubmenu))
            defaultItem = previousItem;
    };
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Controls

with (new OptionsMenu_Submenu("controls", "CONTROLS")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_ControlBinding(true));
	array_push(_items, new OptionsMenu_Item_ControlBinding(false));
	array_push(_items, new OptionsMenu_Item_Toggle("downJumpSlide", "DOWN+JUMP", false, ["NONE", "SLIDE"]));
    with (new OptionsMenu_Item("autofire", "AUTO FIRE")) {
        onRefreshValue = function() /*=>*/ {return options_data().autoFire ? "ON" : "OFF"};
        onXDir = function(__) {
            var _optionsData = options_data();
            
            _optionsData.autoFire = !_optionsData.autoFire;
            refresh_value();
            play_sfx(sfxMenuMove);
            
            if (_optionsData.autoFire && !_optionsData.chargeToggle) {
                _optionsData.chargeToggle = true;
                submenu.get_item("chargetoggle").refresh_value();
            }
        };
        array_push(_items, self);
    }
    with (new OptionsMenu_Item("chargetoggle", "CHARGE TOGGLE")) {
        onRefreshValue = function() /*=>*/ {return options_data().chargeToggle ? "ON" : "OFF"};
        onXDir = function(__) {
            var _optionsData = options_data();
            
            _optionsData.chargeToggle = !_optionsData.chargeToggle;
            refresh_value();
            play_sfx(sfxMenuMove);
            
            if (!_optionsData.chargeToggle && _optionsData.autoFire) {
                _optionsData.autoFire = false;
                submenu.get_item("autofire").refresh_value();
            }
        };
        array_push(_items, self);
    }
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Display

with (new OptionsMenu_Submenu("display", "DISPLAY")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_Toggle("fullscreen", "FULLSCREEN", true));
    with (new OptionsMenu_Item("screensize", "SCREEN SIZE")) {
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
        array_push(_items, self);
    }
    array_push(_items, new OptionsMenu_Item_Toggle("pixelPerfect", "PIXEL PERFECT", true));
    array_push(_items, new OptionsMenu_Item_Toggle("vsync", "VSYNC", true));
    array_push(_items, new OptionsMenu_Item_Toggle("showFPS", "SHOW FPS"));
    
    add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Audio

with (new OptionsMenu_Submenu("audio", "AUDIO")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeMaster", "MASTER VOLUME"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeMusic", "MUSIC VOLUME"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeSound", "SOUND VOLUME"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Other

with (new OptionsMenu_Submenu("misc", "OTHER")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	with (new OptionsMenu_Item("gamespeed", "GAME SPEED")) {
        onRefreshValue = function() /*=>*/ {return (options_data().gameSpeed == 1) ? "NTSC" : "PAL"};
        onXDir = function(__) {
            var _newSpeed = (options_data().gameSpeed == 1) ? 50/60 : 1;
            options_data().gameSpeed = _newSpeed;
            play_sfx(sfxMenuMove);
            refresh_value();
        };
        array_push(_items, self);
    }
	array_push(_items, new OptionsMenu_Item_Toggle("chargeBar", "CHARGE BAR"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

with (menu) {
	for (var i = 0; i < submenuCount; i++) {
		with (submenus[i]) {
			refresh_item_values();
			defaultItem = items[0];
		}
	}
	
	defaultSubmenu = submenus[0];
	pass_submenu_focus(defaultSubmenu);
}