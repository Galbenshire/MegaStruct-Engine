inputs = global.player.inputs;

optionsDataRef = options_data();
gameWindowRef = game_window();
gameViewRef = game_view();

options = [
    {
        label: "BACK",
        onSelect: function() /*=>*/ { go_to_room(rmTitleScreen); }
    },
    { label: "== CONTROLS ==" },
    {
        label: "DOWN+JUMP",
        display: optionsDataRef.downJumpSlide ? "SLIDE" : "NONE",
        onXDirInput: function (_dir) {
            other.optionsDataRef.downJumpSlide = !other.optionsDataRef.downJumpSlide;
            display = other.optionsDataRef.downJumpSlide ? "SLIDE" : "NONE";
        }
    },
    { label: "== DISPLAY ==" },
    {
        label: "FULLSCREEN",
        display: optionsDataRef.fullscreen ? "ON" : "OFF",
        onXDirInput: function (_dir) {
            other.optionsDataRef.set_fullscreen(!other.optionsDataRef.fullscreen);
            other.gameWindowRef.update_screen();
        }
    },
    {
        label: "SCREEN SIZE",
        display: string(optionsDataRef.screenSize),
        onXDirInput: function (_dir) {
            other.optionsDataRef.set_screen_size(real(display) + _dir);
            other.gameWindowRef.update_screen();
        }
    },
    {
        label: "PIXEL PERFECT",
        display: optionsDataRef.pixelPerfect ? "ON" : "OFF",
        onXDirInput: function (_dir) {
            other.optionsDataRef.set_pixel_perfect(!other.optionsDataRef.pixelPerfect);
            other.gameWindowRef.update_screen();
        }
    },
    {
        label: "VSYNC",
        display: optionsDataRef.vsync ? "ON" : "OFF",
        onXDirInput: function (_dir) {
            other.optionsDataRef.set_vsync(!other.optionsDataRef.vsync);
            other.gameWindowRef.update_screen();
            display = other.optionsDataRef.vsync ? "ON" : "OFF";
        }
    },
    {
        label: "SHOW FPS",
        display: optionsDataRef.showFPS ? "ON" : "OFF",
        onXDirInput: function (_dir) {
            other.optionsDataRef.showFPS = !other.optionsDataRef.showFPS;
            display = other.optionsDataRef.showFPS ? "ON" : "OFF";
        }
    },
    { label: "== SOUND ==" },
    {
        label: "MASTER VOLUME",
        display: string(optionsDataRef.volumeMaster * 100),
        onXDirInput: function (_dir) {
            var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
            other.optionsDataRef.set_master_volume(_newVolume);
            display = string(other.optionsDataRef.volumeMaster * 100);
        }
    },
    {
        label: "MUSIC VOLUME",
        display: string(optionsDataRef.volumeMusic * 100),
        onXDirInput: function (_dir) {
            var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
            other.optionsDataRef.set_music_volume(_newVolume);
            display = string(other.optionsDataRef.volumeMusic * 100);
        }
    },
    {
        label: "SFX VOLUME",
        display: string(optionsDataRef.volumeSound * 100),
        onXDirInput: function (_dir) {
            var _newVolume = clamp(real(display) + 10 * _dir, 0, 100);
            other.optionsDataRef.set_sound_volume(_newVolume);
            display = string(other.optionsDataRef.volumeSound * 100);
        }
    }
];

optionCount = array_length(options);
optionIndex = 0;
currentOption = options[optionIndex];

// These settings are also modified by debug keys, so these must be updated in real-time
fullscreenOption = array_find_index(options, function(_option, _i) /*=>*/ {return _option.label == "FULLSCREEN"});
screenSizeOption = array_find_index(options, function(_option, _i) /*=>*/ {return _option.label == "SCREEN SIZE"});
pixelPerfectOption = array_find_index(options, function(_option, _i) /*=>*/ {return _option.label == "PIXEL PERFECT"});