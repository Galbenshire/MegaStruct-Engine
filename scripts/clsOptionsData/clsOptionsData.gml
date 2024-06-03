/// === SINGLETON ===
/// @func OptionsData()
/// @desc Represents options data that can be saved & loaded
function OptionsData() constructor {
	ENFORCE_SINGLETON
	
	#region Constants (in spirit)
	
	/// Name of the file to load/save data
	static FILENAME = "options.sav";
	
	/// A constant for the highest the 'screenSize' variable can be
	static MAX_SCALE = min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT);
	
	#endregion

    #region Variables
    
    // Display
    screenSize = floor(max(MAX_SCALE - 1, 1));
    fullscreen = false;
    pixelPerfect = false;
    vsync = false;
    showFPS = false;
    
    // Volume
    volumeMaster = 1;
    volumeMusic = 0.8;
    volumeSound = 1;
    
    // Controls
    keys = default_key_bindings(); /// @is {array<int>}
    buttons = default_button_bindings(); /// @is {array<gamepad_button>}
    downJumpSlide = true;
    autoFire = false;
    chargeToggle = false;
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_master_volume()
	/// @desc Gets the master volume; which controls the loudness of ALL sounds in this game.
	/// 	  The value will be in a 0-1 range, where 0 is mute & 1 is max volume.
	///
	/// @returns {number}  The master volume
    static get_master_volume = function() {
        return volumeMaster;
    };
    
    /// @method get_music_volume(ignore_master)
	/// @desc Gets the music volume; which affects the loudness of music in this game.
	/// 	  The value will be in a 0-1 range, where 0 is mute & 1 is max volume.
	///
	/// @param {bool}  [ignore_master]  If true, assumes master volume is at max. Defaults to false.
	///
	/// @returns {number}  The music volume
    static get_music_volume = function(_ignoreMaster/*: bool*/ = false) {
        return volumeMusic * (_ignoreMaster ? 1 : volumeMaster);
    };
    
    /// @method get_sound_volume(ignore_master)
	/// @desc Gets the master volume; which affects the loudness of sound effects in this game.
	/// 	  The value will be in a 0-1 range, where 0 is mute & 1 is max volume.
	///
	/// @param {bool}  [ignore_master]  If true, assumes master volume is at max. Defaults to false.
	///
	/// @returns {number}  The sound volume
    static get_sound_volume = function(_ignoreMaster/*: bool*/ = false) {
        return volumeSound * (_ignoreMaster ? 1 : volumeMaster);
    };
    
    #endregion
    
    #region Functions - Setters - Display
    
    /// @method set_fullscreen(is_fullscreen)
	/// @desc Sets the game as being in fullscreen, taking up your entire monitor screen
	///
	/// @param {bool}  is_fullscreen  Whether the game should be in fullscreen(true) or not(false)
	static set_fullscreen = function(_fullscreen/*: bool*/) {
		fullscreen = bool(_fullscreen); // Ensures 'fullscreen' stays a boolean value
	};
	
	/// @method set_pixel_perfect(is_pixel_perfect)
	/// @desc Sets whether the screen has pixel perfect scaling
	/// 	  i.e. the base game resolution is forced regardless of the size of the window
	///
	/// @param {bool}  is_pixel_perfect  Whether pixel perfect scaling is applied(true) or not(false)
	static set_pixel_perfect = function(_pixelPerfect/*: bool*/) {
		pixelPerfect = bool(_pixelPerfect); // Ensures 'pixelPerfect' stays a boolean value
	};
    
    /// @method set_scale(new_scale)
	/// @desc Sets the scale of the game window.
	///
	/// @param {number}  new_scale  The new scale of the game screen
	static set_screen_size = function(_scale/*: number*/) {
		screenSize = floor(clamp(_scale, 1, MAX_SCALE));
	};
	
	/// @method set_vsync(enable)
	/// @desc Sets whether vertical synchronisation should be enabled or not
	///
	/// @param {bool}  enable  Enabled v-sync if true
	static set_vsync = function(_enable/*: bool*/) {
		vsync = bool(_enable);
	};
    
    #endregion
    
    #region Functions - Setters - Volume
    
    /// @method set_master_volume(percentage)
	/// @desc Sets the master volume by a percentage. This will affect the loudness of ALL sounds in this game.
	///
	/// @param {number}  percentage  The percentage at which to set the volume
    static set_master_volume = function(_percentage/*: number*/) {
        _percentage = clamp(_percentage, 0, 100);
        volumeMaster = _percentage * 0.01;
    };
    
    /// @method set_music_volume(percentage)
	/// @desc Sets the music volume by a percentage. This will affect the loudness of music in this game.
	///
	/// @param {number}  percentage  The percentage at which to set the volume
    static set_music_volume = function(_percentage/*: number*/) {
        _percentage = clamp(_percentage, 0, 100);
        volumeMusic = _percentage * 0.01;
    };
    
    /// @method set_sound_volume(percentage)
	/// @desc Sets the sound volume by a percentage. This will affect the loudness of sound effects in this game.
	///
	/// @param {number}  percentage  The percentage at which to set the volume
    static set_sound_volume = function(_percentage/*: number*/) {
        _percentage = clamp(_percentage, 0, 100);
        volumeSound = _percentage * 0.01;
    };
    
    #endregion
    
    #region Functions - Controls
    
    /// -- default_button_bindings()
	/// Returns the default gamepad bindings for this game
	///
	/// @returns {array<gamepad_button>}  Default button bindings
    static default_button_bindings = function() {
        var _defaults = array_create(InputActions.COUNT);
        
        _defaults[InputActions.LEFT] = gp_padl;
        _defaults[InputActions.RIGHT] = gp_padr;
        _defaults[InputActions.UP] = gp_padu;
        _defaults[InputActions.DOWN] = gp_padd;
        
        _defaults[InputActions.JUMP] = gp_face1;
        _defaults[InputActions.SHOOT] = gp_face3;
        _defaults[InputActions.SLIDE] = gp_face2;
        
        _defaults[InputActions.WEAPON_SWITCH_LEFT] = gp_shoulderlb;
		_defaults[InputActions.WEAPON_SWITCH_RIGHT] = gp_shoulderrb;
		
		_defaults[InputActions.PAUSE] = gp_start;
        
        return _defaults;
    };
    
    /// -- default_button_bindings()
	/// Returns the default keyboard bindings for this game
	///
	/// @returns {array<int>}  Default key bindings
    static default_key_bindings = function() {
        var _defaults = array_create(InputActions.COUNT);
        
        _defaults[InputActions.LEFT] = vk_left;
        _defaults[InputActions.RIGHT] = vk_right;
        _defaults[InputActions.UP] = vk_up;
        _defaults[InputActions.DOWN] = vk_down;
        
        _defaults[InputActions.JUMP] = ord("Z");
        _defaults[InputActions.SHOOT] = ord("X");
        _defaults[InputActions.SLIDE] = ord("C");
        
        _defaults[InputActions.WEAPON_SWITCH_LEFT] = ord("A");
		_defaults[InputActions.WEAPON_SWITCH_RIGHT] = ord("S");
		
		_defaults[InputActions.PAUSE] = vk_enter;
        
        return _defaults;
    };
    
    #endregion
    
    #region Functions - Save/Load
    
    /// @method load_from_file()
	/// @desc Grabs from options.sav to load options
    static load_from_file = function() {
        show_debug_message("Loading Options...");
        
        var _file = file_text_open_read(FILENAME);
        if (_file == NOT_FOUND)
            return;
        
        var _data = json_parse(file_text_readln(_file)),
            _dataKeys = struct_get_names(_data),
            _dataSize = array_length(_dataKeys);
        
        for (var i = 0; i < _dataSize; i++)
            struct_set(self, _dataKeys[i], _data[$ _dataKeys[i]]);
        
        file_text_close(_file);
        
        show_debug_message("...Options Loaded successfully");
    };
    
    /// @method save_to_file()
	/// @desc Takes the current options values and writes them to options.sav
    static save_to_file = function() {
        show_debug_message("Saving Options...");
        
        var _file = file_text_open_write(FILENAME);
        if (_file == NOT_FOUND)
            return;
        
        var _dataKeys = struct_get_names(self),
            _dataKeyCount = array_length(_dataKeys),
            _data = {};
        
        for (var i = 0; i < _dataKeyCount; i++)
            struct_set(_data, _dataKeys[i], self[$ _dataKeys[i]]);
        
        file_text_write_string(_file, json_stringify(_data));
        file_text_close(_file);
        
        show_debug_message("...Options Saved successfully");
    };
    
    #endregion
    
    #region Functions - Debug
    
    static debug_view = function() {
        var _view = dbg_view("Options Data", false, -1, -1, 300, 380);
        
        var _display = dbg_section("Display");
        dbg_slider_int(ref_create(self, "screenSize"), 1, floor(MAX_SCALE), "Screen Size");
        dbg_checkbox(ref_create(self, "fullscreen"), "Fullscreen");
        dbg_checkbox(ref_create(self, "pixelPerfect"), "Pixel Perfect");
        dbg_checkbox(ref_create(self, "vsync"), "VSync");
        dbg_checkbox(ref_create(self, "showFPS"), "Show FPS");
        dbg_button("Update Screen", function() {
			game_window().update_screen();
			game_window().center_window();
		});
        
        var _volume = dbg_section("Volume");
        dbg_slider(ref_create(self, "volumeMaster"), 0, 1, "Master");
        dbg_slider(ref_create(self, "volumeMusic"), 0, 1, "Music");
        dbg_slider(ref_create(self, "volumeSound"), 0, 1, "Sound");
        
        var _controls = dbg_section("Controls");
        dbg_checkbox(ref_create(self, "downJumpSlide"), "Down+Jump Slide");
        dbg_checkbox(ref_create(self, "autoFire"), "Auto Fire");
        dbg_checkbox(ref_create(self, "chargeToggle"), "Charge Toggle");
    }
    
    #endregion
}

/// @func options_data()
/// @desc Returns a static instance of OptionsData
///
/// @returns {OptionsData}  A reference to this OptionsData static.
function options_data() {
	static _instance = new OptionsData();
	return _instance;
}
