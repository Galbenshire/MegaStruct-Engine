/// @func ParallaxLayer(sprite, image_index)
/// @desc Represents a parallax scrolling layer to be used with objParallax
///
/// @param {number}  [initial_value]  Starting value. Defaults to 0.
function ParallaxLayer(_sprite, _imgIndex = 0) constructor {
    #region Variables
    
    x = 0;
    y = 0;
    
    sprite = _sprite;
    imgIndex = _imgIndex;
    animSpeed = 0;
    
    imgBlend = c_white;
    imgAlpha = 1;
    
    parallaxX = 1;
    parallaxY = 1;
    
    scaleX = 1;
    scaleY = 1;
    
    speedX = 0;
    speedY = 0;
    
    wrapX = false;
    wrapY = false;
    
    areaLeft = 0;
    areaTop = 0;
    areaWidth = sprite_get_width(sprite);
    areaHeight = sprite_get_height(sprite);
    
    widthSegments = 1;
    heightSegments = 1;
    isWholeSprite = true;
    
    #endregion
    
    #region Functions - Setters
    
    /// @method set_anim_speed(speed)
	/// @desc Sets the animation speed of this layer
	///
	/// @param {number}  speed  The rate at which the layer should animate
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_anim_speed = function(_spd) {
        animSpeed = _spd;
        return self;
    };
    
    /// @method set_area(left, top, width, height)
	/// @desc Sets the area of the sprite that should be used
	///
	/// @param {int}  left  The x position on the sprite of the top-left corner of the area
	/// @param {int}  top  The y position on the sprite of the top-left corner of the area
	/// @param {int}  width  The width of the area to draw
	/// @param {int}  height  The height of the area to draw
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_area = function(_left, _top, _width, _height) {
        areaLeft = _left;
        areaTop = _top;
        areaWidth = _width;
        areaHeight = _height;
        isWholeSprite = (areaLeft == 0 && areaTop == 0 && areaWidth == sprite_get_width(sprite) && areaHeight == sprite_get_height(sprite));
        return self;
    };
    
    /// @method set_alpha(alpha)
	/// @desc Sets the alpha of this layer
	///
	/// @param {number}  alpha  The alpha for the layer
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_alpha = function(_alpha) {
        imgAlpha = clamp(_alpha, 0, 1);
        return self;
    };
    
    /// @method set_blend(blend)
	/// @desc Sets the colour blending of this layer
	///
	/// @param {int}  blend  The color blend for the layer
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_blend = function(_blend) {
        imgBlend = _blend;
        return self;
    };
    
    /// @method set_offset(x, y)
	/// @desc Sets the offset of this layer. This does not take into account parallax values.
	///
	/// @param {int}  x  Horizontal offset
	/// @param {int}  y  Vertical offset
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_offset = function(_x, _y) {
        x = _x;
        y = _y;
        return self;
    };
    
    /// @method set_parallax(x, y)
	/// @desc Sets the parallax of this layer.
	///       >1 = Moves faster than the camera
	///       1 = Moves at the same speed as the camera
	///       (0,1) = Moves slower than the camera
	///       0 = Fixed in place on the screen
	///       <0 = Moves in the opposite direction of the camera
	///
	/// @param {int}  x  Horizontal parallax
	/// @param {int}  y  Vertical parallax
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_parallax = function(_parX, _parY) {
        parallaxX = _parX;
        parallaxY = _parY;
        return self;
    };
    
    /// @method set_scale(x, y)
	/// @desc Sets the scale of this layer
	///
	/// @param {int}  x  Horizontal scale
	/// @param {int}  y  Vertical scale
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_scale = function(_x, _y) {
        scaleX = _x;
        scaleY = _y;
        return self;
    };
    
    /// @method set_speed(x, y, relative)
	/// @desc Sets the speed of this layer
	///
	/// @param {int}  x  Horizontal speed
	/// @param {int}  y  Vertical speed
	/// @param {bool}  [relative]  Whether we should take into account the layer's parallax (true) or not (false, default)
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_speed = function(_xspeed, _yspeed, _relative = false) {
        if (_relative) {
            _xspeed *= parallaxX;
            _yspeed *= parallaxY;
        }
        speedX = _xspeed;
        speedY = _yspeed;
        return self;
    };
    
    /// @method set_sprite(sprite, image_index)
	/// @desc Sets the sprite for this layer
	///
	/// @param {sprite}  sprite  The sprite to use for this layer
	/// @param {int}  [image_index]  The frame of the sprite to use. Defaults to 0: the first frame.
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_sprite = function(_sprite, _imgIndex = 0) {
        sprite = _sprite;
        imgIndex = _imgIndex;
        return self;
    };
    
    /// @method set_wrapping(wrap_x, wrap_y)
	/// @desc Sets if the parallax layer should wrap around within its bounds
	///
	/// @param {bool}  wrap_x  Whether this layer should wrap arounnd horizontally (true) or not (false)
	/// @param {bool}  wrap_y  Whether this layer should wrap arounnd horizontally (true) or not (false)
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static set_wrapping = function(_wrapX, _wrapY) {
        wrapX = bool(_wrapX);
        wrapY = bool(_wrapY);
        return self;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method calculate_segments(section_width, section_height)
	/// @desc Calculates the numbers of segments needed to draw this layer
	///
	/// @param {int}  section_width  The width of the area of parallax
	/// @param {int}  section_height  The height of the area of parallax
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static calculate_segments = function(_sectionWidth, _sectionHeight) {
        var _segmentWidth = areaWidth * scaleX,
            _segmentHeight = areaHeight * scaleY;
        _sectionWidth = min(_sectionWidth, GAME_WIDTH);
        _sectionHeight = min(_sectionHeight, GAME_WIDTH);
        
        widthSegments = wrapX ? ceil(_sectionWidth / _segmentWidth) + 1 : 1;
        heightSegments = wrapY ? ceil(_sectionHeight / _segmentHeight) + 1 : 1;
        
        return self;
    };
    
    /// @method draw(view_x, view_y)
	/// @desc Draws this parallax layer
	///
	/// @param {number}  view_x  The horizontal position of the camera
	/// @param {number}  view_y  The vertical position of the camera
    static draw = function(_viewX, _viewY) {
        if (imgAlpha <= 0)
            return;
        
        var _drawX = x - _viewX * (parallaxX - 1),
            _drawY = y - _viewY * (parallaxY - 1);
        _drawX = floor_to(_drawX, 1/16);
        _drawY = floor_to(_drawY, 1/16);
        
        if (wrapX && wrapY && isWholeSprite) {
            draw_sprite_tiled_ext(sprite, imgIndex, _drawX, _drawY, scaleX, scaleY, imgBlend, imgAlpha);
            return;
        }
        if (!wrapX && !wrapY) {
            draw_sprite_part_ext(sprite, imgIndex, areaLeft, areaTop, areaWidth, areaHeight, _drawX, _drawY, scaleX, scaleY, imgBlend, imgAlpha);
            return;
        }
        
        var _segmentWidth = scaleX * areaWidth,
            _segmentHeight = scaleY * areaHeight;
        
        if (wrapX) {
            var _xDiff = _viewX - _drawX,
                _xOverflow = (abs(_xDiff) div _segmentWidth) + 1 * (_xDiff < 0);
            _drawX += _segmentWidth * _xOverflow * sign(_xDiff);
        }
        if (wrapY) {
            var _yDiff = _viewY - _y,
                _yOverflow = (abs(_yDiff) div _segmentHeight) + 1 * (_yDiff < 0);
            _drawY += _segmentHeight * _yOverflow * sign(_yDiff);
        }
        
        var i = 0; repeat(widthSegments) {
            var j = 0; repeat(heightSegments) {
                draw_sprite_part_ext(sprite, imgIndex, areaLeft, areaTop, areaWidth, areaHeight, _drawX + _segmentWidth * i, _drawY + _segmentHeight * j, scaleX, scaleY, imgBlend, imgAlpha);
                j++;
            }
            i++;
        }
    };
    
    /// @method shift_by(x, y, relative)
	/// @desc Shifts this layer by the specified amount
	///
	/// @param {int}  x  Horizontal offset
	/// @param {int}  y  Vertical offset
	/// @param {bool}  [relative]  Whether we should take into account the layer's parallax (true) or not (false, default)
	///
	/// @returns {ParallaxLayer}  A reference to this struct. Useful for method chaining.
    static shift_by = function(_x, _y, _relative = true) {
        if (_relative) {
            _x *= parallaxX;
            _y *= parallaxY;
        }
        x += _x;
        y += _y;
        return self;
    };
    
    /// @method update()
	/// @desc Updates various parameters on this layer
    static update = function() {
        x += speedX;
        y += speedY;
        imgIndex += animSpeed;
    };
    
    #endregion
}