/// === SINGLETON ===
/// @func GameView()
/// @desc Represents the in-game view. The game's camera, in other words.
function GameView() constructor {
	ENFORCE_SINGLETON
	
    #region Variables
    
    // Position of the game view
	xView = 0;
	yView = 0;
	
	// Previous position of the game view
	xPrev = 0;
	yPrev = 0;
	
	// Offset from the view's current position.
	// This can allow for screen-moving effects, such as screen shakes,
	// while allowing to reset to the initial position afterwards.
	xOffset = 0;
	yOffset = 0;
	
	#endregion
	
	#region Functions - Getters
    
    /// -- get_x(include_offset)
	/// Gets the x-position of the game view
	///
	/// @param {bool}  [include_offset]  Whether to include the view's offset. Defaults to true.
	///
	/// @returns {number}  x-position of the game view
    static get_x = function(_includeOffset/*:bool*/ = true) {
        return xView + xOffset * _includeOffset;
    };
    
    /// -- get_y(include_offset)
	/// Gets the y-position of the game view
	///
	/// @param {bool}  [include_offset]  Whether to include the view's offset. Defaults to true.
	///
	/// @returns {number}  y-position of the game view
    static get_y = function(_includeOffset/*:bool*/ = true) {
        return yView + yOffset * _includeOffset;
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// -- set_offset(x, y)
	/// Sets the offset for the game view
	///
	/// @param {number}  x  x-component of the offset
	/// @param {number}  y  y-component of the offset
    static set_offset = function(_x/*:number*/, _y/*:number*/) {
        xOffset = _x;
        yOffset = _y;
    };
    
    /// -- set_position(x, y)
	/// Sets the position of the game view
	///
	/// @param {number}  x  New X Position
	/// @param {number}  y  New Y Position
	static set_position = function(_x/*:number*/, _y/*:number*/) {
		xView = _x;
		yView = _y;
	};
	
	/// -- set_prev_position(x, y)
	/// Sets the previous position of the game view
	///
	/// @param {number}  x  New X Position
	/// @param {number}  y  New Y Position
	static set_prev_position = function(_x/*:number*/, _y/*:number*/) {
		xPrev = _x;
		yPrev = _y;
	};
    
    #endregion
    
    #region Functions - Centers
    
    /// -- center_x(include_offset)
	/// Returns the x-center of the game view
	///
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  X-center of the game view
	static center_x = function(_includeOffset/*:bool*/ = true) {
		return get_x(_includeOffset) + GAME_WIDTH * 0.5;
	};
	
	/// -- center_y(include_offset)
	/// Returns the y-center of the game view
	///
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Y-center of the game view
	static center_y = function(_includeOffset/*:bool*/ = true) {
		return get_y(_includeOffset) + GAME_HEIGHT * 0.5;
	};
    
    #endregion
    
    #region Functions - Edges
    
    /// -- view_left_edge(shift_by, include_offset)
	/// Returns the left side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Left edge of the screen (in x-position), with an optional shift
	static left_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_x(_includeOffset) + _shift;
	};
	
	/// -- view_right_edge(shift_by, include_offset)
	/// Returns the right side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Right edge of the screen (in x-position), with an optional shift
	static right_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return left_edge(GAME_WIDTH + _shift, _includeOffset);
	};
	
	/// -- view_top_edge(shift_by, include_offset)
	/// Returns the top side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Top edge of the screen (in y-position), with an optional shift
	static top_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_y(_includeOffset) + _shift;
	};
	
	/// -- view_bottom_edge(shift_by, include_offset)
	/// Returns the bottom side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Bottom edge of the screen (in y-position), with an optional shift
	static bottom_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return top_edge(GAME_HEIGHT + _shift, _includeOffset);
	};
    
    #endregion
    
    #region Functions - Other
    
    /// -- add_offset(x, y)
	/// Applies an offset to the game view
	///
	/// @param {number}  x  x-component of the offset
	/// @param {number}  y  y-component of the offset
    static add_offset = function(_x/*:number*/, _y/*:number*/) {
        xOffset += _x;
        yOffset += _y;
    };
    
    /// -- move_position(x, y)
	/// Moves the game view by a set amount
	///
	/// @param {number}  x  The number of pixels to move horizontally
	/// @param {number}  y  The number of pixels to move vertically
    static move_position = function(_x/*:number*/, _y/*:number*/) {
    	xView += _x;
    	yView += _y;
    };
    
    /// -- reset_offset()
	/// Resets the offset for this view
    static reset_offset = function() {
        xOffset = 0;
        yOffset = 0;
    };
    
    /// -- reset_all()
	/// Resets the view co-ordinates. Usually called when a room starts
    static reset_all = function() {
        xView = 0;
		yView = 0;
		xPrev = 0;
		yPrev = 0;
		xOffset = 0;
		yOffset = 0;
    };
    
    #endregion
}

/// @func game_view()
/// @desc Returns a static instance of GameView
///
/// @returns {GameView}  A reference to this GameView static.
function game_view() {
	static _instance = new GameView();
	return _instance;
}
