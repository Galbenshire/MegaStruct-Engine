inputs = global.player.inputs;

optionsDataRef = options_data();
gameWindowRef = game_window();
gameViewRef = game_view();

submenus = [
    {
        name: "CONTROLS",
        options: [
            {
                label: "DOWN+JUMP",
                display: optionsDataRef.downJumpSlide ? "SLIDE" : "NONE",
                onXDirInput: function(_dir) /*=>*/ { other.optionsDataRef.downJumpSlide = !other.optionsDataRef.downJumpSlide; },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.downJumpSlide ? "SLIDE" : "NONE"; }
            },
            {
                label: "AUTO FIRE",
                display: optionsDataRef.autoFire ? "ON" : "OFF",
                onXDirInput: function(_dir) /*=>*/ { other.optionsDataRef.autoFire = !other.optionsDataRef.autoFire; },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.autoFire ? "ON" : "OFF"; }
            },
            {
                label: "CHARGE TOGGLE",
                display: optionsDataRef.chargeToggle ? "ON" : "OFF",
                onXDirInput: function(_dir) /*=>*/ { other.optionsDataRef.chargeToggle = !other.optionsDataRef.chargeToggle; },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.chargeToggle ? "ON" : "OFF"; }
            }
        ]
    },
    {
        name: "DISPLAY",
        options: [
            {
                label: "FULLSCREEN",
                display: optionsDataRef.fullscreen ? "ON" : "OFF",
                onXDirInput: function (_dir) {
                    other.optionsDataRef.set_fullscreen(!other.optionsDataRef.fullscreen);
                    other.gameWindowRef.update_screen();
                },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.fullscreen ? "ON" : "OFF"; }
            },
            {
                label: "SCREEN SIZE",
                display: string(optionsDataRef.screenSize),
                onXDirInput: function (_dir) {
                    other.optionsDataRef.set_screen_size(real(display) + _dir);
                    other.gameWindowRef.update_screen();
                },
                onUpdateLabel: function() /*=>*/ { display = string(other.optionsDataRef.screenSize); }
            },
            {
                label: "PIXEL PERFECT",
                display: optionsDataRef.pixelPerfect ? "ON" : "OFF",
                onXDirInput: function (_dir) {
                    other.optionsDataRef.set_pixel_perfect(!other.optionsDataRef.pixelPerfect);
                    other.gameWindowRef.update_screen();
                },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.pixelPerfect ? "ON" : "OFF"; }
            },
            {
                label: "VSYNC",
                display: optionsDataRef.vsync ? "ON" : "OFF",
                onXDirInput: function (_dir) {
                    other.optionsDataRef.set_vsync(!other.optionsDataRef.vsync);
                    other.gameWindowRef.update_screen();
                },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.vsync ? "ON" : "OFF"; }
            },
            {
                label: "SHOW FPS",
                display: optionsDataRef.showFPS ? "ON" : "OFF",
                onXDirInput: function(_dir) /*=>*/ { other.optionsDataRef.showFPS = !other.optionsDataRef.showFPS; },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.showFPS ? "ON" : "OFF"; }
            }
        ]
    },
    {
        name: "SOUND",
        options: [
            {
                label: "MASTER VOLUME",
                display: string(optionsDataRef.volumeMaster * 100),
                onXDirInput: function (_dir) {
                    var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
                    other.optionsDataRef.set_master_volume(_newVolume);
                },
                onUpdateLabel: function() /*=>*/ { display = string(other.optionsDataRef.volumeMaster * 100); }
            },
            {
                label: "MUSIC VOLUME",
                display: string(optionsDataRef.volumeMusic * 100),
                onXDirInput: function (_dir) {
                    var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
                    other.optionsDataRef.set_music_volume(_newVolume);
                },
                onUpdateLabel: function() /*=>*/ { display = string(other.optionsDataRef.volumeMusic * 100); }
            },
            {
                label: "SFX VOLUME",
                display: string(optionsDataRef.volumeSound * 100),
                onXDirInput: function (_dir) {
                    var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
                    other.optionsDataRef.set_sound_volume(_newVolume);
                },
                onUpdateLabel: function() /*=>*/ { display = string(other.optionsDataRef.volumeSound * 100); }
            }
        ]
    },
    {
        name: "OTHER",
        options: [
            {
                label: "GAME SPEED",
                display: (optionsDataRef.gameSpeed == 1) ? "NTSC" : "PAL",
                onXDirInput: function (_dir) {
                    var _newSpeed = (other.optionsDataRef.gameSpeed == 1) ? 50/60 : 1;
                    other.optionsDataRef.gameSpeed = _newSpeed;
                },
                onUpdateLabel: function() /*=>*/ { display = (other.optionsDataRef.gameSpeed == 1) ? "NTSC" : "PAL"; }
            },
            {
                label: "CHARGE BAR",
                display: optionsDataRef.chargeBar ? "ON" : "OFF",
                onXDirInput: function(_dir) /*=>*/ { other.optionsDataRef.chargeBar = !other.optionsDataRef.chargeBar; },
                onUpdateLabel: function() /*=>*/ { display = other.optionsDataRef.chargeBar ? "ON" : "OFF"; }
            },
        ]
    },
];

submenuCount = array_length(submenus);
submenuIndex = 0;
currentSubmenu = submenus[submenuIndex];

optionCount = array_length(currentSubmenu.options);
optionIndex = 0;
currentOption = currentSubmenu.options[optionIndex];

displaySubmenu = array_find_index(submenus, function(_submenu, _i) /*=>*/ {return _submenu.name == "DISPLAY"});
displaySubmenuOptionCount = array_length(submenus[displaySubmenu].options);
signal_bus().connect_to_signal("appSurfaceResize", self, function(_data) /*=>*/ { event_user(0); });