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
    
    /// @method get_x(include_offset)
	/// @desc Gets the x-position of the game view
	///
	/// @param {bool}  [include_offset]  Whether to include the view's offset. Defaults to true.
	///
	/// @returns {number}  x-position of the game view
    static get_x = function(_includeOffset/*:bool*/ = true) {
        return xView + xOffset * _includeOffset;
    };
    
    /// @method get_y(include_offset)
	/// @desc Gets the y-position of the game view
	///
	/// @param {bool}  [include_offset]  Whether to include the view's offset. Defaults to true.
	///
	/// @returns {number}  y-position of the game view
    static get_y = function(_includeOffset/*:bool*/ = true) {
        return yView + yOffset * _includeOffset;
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// @method set_offset(x, y)
	/// @desc Sets the offset for the game view
	///
	/// @param {number}  x  x-component of the offset
	/// @param {number}  y  y-component of the offset
    static set_offset = function(_x/*:number*/, _y/*:number*/) {
        xOffset = _x;
        yOffset = _y;
    };
    
    /// @method set_position(x, y)
	/// @desc Sets the position of the game view
	///
	/// @param {number}  x  New X Position
	/// @param {number}  y  New Y Position
	static set_position = function(_x/*:number*/, _y/*:number*/) {
		xView = _x;
		yView = _y;
	};
	
	/// @method set_prev_position(x, y)
	/// @desc Sets the previous position of the game view
	///
	/// @param {number}  x  New X Position
	/// @param {number}  y  New Y Position
	static set_prev_position = function(_x/*:number*/, _y/*:number*/) {
		xPrev = _x;
		yPrev = _y;
	};
    
    #endregion
    
    #region Functions - Centers
    
    /// @method center_x(include_offset)
	/// @desc Returns the x-center of the game view
	///
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  X-center of the game view
	static center_x = function(_includeOffset/*:bool*/ = true) {
		return get_x(_includeOffset) + GAME_WIDTH * 0.5;
	};
	
	/// @method center_y(include_offset)
	/// @desc Returns the y-center of the game view
	///
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Y-center of the game view
	static center_y = function(_includeOffset/*:bool*/ = true) {
		return get_y(_includeOffset) + GAME_HEIGHT * 0.5;
	};
	
	/// @method direction_to_center_x(x, include_offset)
	/// @desc Returns the direction away from the x-center of the screen
	///		  (i.e. which side of the screen the given position is)
	/// 	  1 = target is on the right side of the screen
	/// 	  0 = target is directly in the x-center of the screen
	/// 	  -1 = target is on the left side of the screen
	///
	/// @param {number}  x  The x-position to check with.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  The direction relative to the x-center
	static direction_to_center_x = function(_x/*:number*/, _includeOffset/*:bool*/ = true) {
		return sign(_x - self.center_x(_includeOffset));
	};
	
	/// @method direction_to_center_y(y, include_offset)
	/// @desc Returns the direction away from the y-center of the screen
	///		  (i.e. which side of the screen the given position is)
	/// 	  1 = target is on the bottom of the screen
	/// 	  0 = target is directly in the y-center of the screen
	/// 	  -1 = target is on the top of the screen
	///
	/// @param {number}  y  The y-position to check with.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  The direction relative to the y-center
	static direction_to_center_y = function(_y/*:number*/, _includeOffset/*:bool*/ = true) {
		return sign(_y - self.center_y(_includeOffset));
	};
    
    #endregion
    
    #region Functions - Edges
    
    /// @method view_left_edge(shift_by, include_offset)
	/// @desc Returns the left side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Left edge of the screen (in x-position), with an optional shift
	static left_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_x(_includeOffset) + _shift;
	};
	
	/// @method view_right_edge(shift_by, include_offset)
	/// @desc Returns the right side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Right edge of the screen (in x-position), with an optional shift
	static right_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_x(_includeOffset) + GAME_WIDTH + _shift;
	};
	
	/// @method view_top_edge(shift_by, include_offset)
	/// @desc Returns the top side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Top edge of the screen (in y-position), with an optional shift
	static top_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_y(_includeOffset) + _shift;
	};
	
	/// @method view_bottom_edge(shift_by, include_offset)
	/// @desc Returns the bottom side of the game view, with an optional shift applied
	///
	/// @param {number}  [shift_by]  Number of pixels to shift from the edge. Defaults to 0.
	/// @param {bool}  [include_offset]  If true, the offset will be factored in. Defaults to true.
	///
	/// @returns {number}  Bottom edge of the screen (in y-position), with an optional shift
	static bottom_edge = function(_shift/*:number*/ = 0, _includeOffset/*:bool*/ = true) {
		return get_y(_includeOffset) + GAME_HEIGHT + _shift;
	};
    
    #endregion
    
    #region Functions - Other
    
    /// @method add_offset(x, y)
	/// @desc Applies an offset to the game view
	///
	/// @param {number}  x  x-component of the offset
	/// @param {number}  y  y-component of the offset
    static add_offset = function(_x/*:number*/, _y/*:number*/) {
        xOffset += _x;
        yOffset += _y;
    };
    
    /// @method move_position(x, y)
	/// @desc Moves the game view by a set amount
	///
	/// @param {number}  x  The number of pixels to move horizontally
	/// @param {number}  y  The number of pixels to move vertically
    static move_position = function(_x/*:number*/, _y/*:number*/) {
    	xView += _x;
    	yView += _y;
    };
    
    /// @method reset_offset()
	/// @desc Resets the offset for this view
    static reset_offset = function() {
        xOffset = 0;
        yOffset = 0;
    };
    
    /// @method reset_all()
	/// @desc Resets the view co-ordinates. Usually called when a room starts
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
