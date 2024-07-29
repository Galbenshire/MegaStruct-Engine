/// === SINGLETON ===
/// @func GameWindow()
/// @desc Represents the window from which you play this game.
///       Manages various actions related to the window,
///       such as resizing, fullscreen, & forcing a base resolution.
function GameWindow() constructor {
	ENFORCE_SINGLETON
	
	#region Functions
	
	/// @method center_window(defer)
	/// @desc Centers the game window
	///
	/// @param {bool}  [defer]  If true, centering is delayed by a single frame. Defaults to true.
	static center_window = function(_defer/*: bool*/ = true) {
		if (_defer)
			time_source_start(__deferWindowCenter);
		else
			window_center();
	};
	
	/// @method update_screen()
	/// @desc Updates the screen, resizing the application surface if needed
	static update_screen = function() {
		with (options_data()) {
			window_set_fullscreen(fullscreen);
			
			if (!fullscreen) {
				window_set_size(GAME_WIDTH * screenSize, GAME_HEIGHT * screenSize);
				window_set_cursor(cr_default);
			} else {
				window_set_cursor(DEBUG_ENABLED ? cr_default : cr_none);
			}
			
			var _scale = pixelPerfect ? 1 : (fullscreen ? MAX_SCALE : screenSize);
			surface_resize(application_surface, GAME_WIDTH * _scale, GAME_HEIGHT * _scale);
			display_set_gui_maximize();
			signal_bus().emit_signal("appSurfaceResize");
			
			display_reset(0, vsync);
		}
	};
	
	#endregion
	
	#region Misc.
	
	static __deferWindowCenter = time_source_create(time_source_global, 2, time_source_units_frames, function() {
		window_center();
	}); /// Time source to delay window centering by a single frame
	
	#endregion
}

/// @func game_window()
/// @desc Returns a static instance of GameWindow
///
/// @returns {GameWindow}  A reference to this GameWindow static.
function game_window() {
	static _instance = new GameWindow();
	return _instance;
}
