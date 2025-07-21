#region Drawing Stuff

/// @func draw_mm_healthbar(x, y, value, colours, alphas, max_value)
/// @desc Draws a Mega Man style health/ammo bar
///
/// @param {number}  x  x-position to draw the healthbar
/// @param {number}  y  y-position to draw the healthbar
/// @param {number}  value  How full to draw the bar. In a [0 - 28] range.
/// @param {PaletteThreeTone}  colours  The palette of the bar
/// @param {PaletteThreeTone}  [alphas]  The opacity of each layer of the bar. Optional
/// @param {number}  [max_value]  Maximum value of the bar. Defaults to 28, the standard for MM health/ammo.
function draw_mm_healthbar(_x, _y, _value, _colours, _alphas, _maxValue = FULL_HEALTHBAR) {
	_value = clamp(ceil(_value), 0, _maxValue);
	_alphas ??= array_create(PaletteThreeTone.sizeof, 1);
	
	draw_sprite_ext(sprHealthbar, 3, _x, _y, 1, _maxValue, 0, _colours[PaletteThreeTone.background], _alphas[PaletteThreeTone.background]);
	
	if (_value > 0) {
		_y += 2 * (_maxValue - _value);
		draw_sprite_ext(sprHealthbar, 2, _x, _y, 1, _value, 0, _colours[PaletteThreeTone.secondary], _alphas[PaletteThreeTone.secondary]);
		draw_sprite_ext(sprHealthbar, 1, _x, _y, 1, _value, 0, _colours[PaletteThreeTone.primary], _alphas[PaletteThreeTone.primary]);
	}
}

/// @func draw_mm_healthbar_horizontal(x, y, value, colours, alphas, max_value)
/// @desc Draws a Mega Man style health/ammo bar
///
/// @param {number}  x  x-position to draw the healthbar
/// @param {number}  y  y-position to draw the healthbar
/// @param {number}  value  How full to draw the bar. In a [0 - 28] range.
/// @param {PaletteThreeTone}  colours  The palette of the bar
/// @param {PaletteThreeTone}  [alphas]  The opacity of each layer of the bar. Optional
/// @param {number}  [max_value]  Maximum value of the bar. Defaults to 28, the standard for MM health/ammo.
function draw_mm_healthbar_horizontal(_x, _y, _value, _colours, _alphas, _maxValue = FULL_HEALTHBAR) {
	_value = clamp(ceil(_value), 0, _maxValue);
	_x += _maxValue * 2;
	_alphas ??= array_create(PaletteThreeTone.sizeof, 1);
	
	draw_sprite_ext(sprHealthbar, 3, _x, _y, 1, _maxValue, -90, _colours[PaletteThreeTone.background], _alphas[PaletteThreeTone.background]);
	
	if (_value > 0) {
		_x -= 2 * (_maxValue - _value);
		draw_sprite_ext(sprHealthbar, 2, _x, _y, 1, _value, -90, _colours[PaletteThreeTone.secondary], _alphas[PaletteThreeTone.secondary]);
		draw_sprite_ext(sprHealthbar, 1, _x, _y, 1, _value, -90, _colours[PaletteThreeTone.primary], _alphas[PaletteThreeTone.primary]);
	}
}

/// @func draw_rectangle_solid(x, y, width, height, colour, alpha)
/// @desc Draws a solid rectangle using a dot sprite
///
/// @param {number}  x  x-position of the rectangle's top-left corner
/// @param {number}  y  y-position of the rectangle's top-left corner
/// @param {number}  width  width of the rectangle's bottom-right corner
/// @param {number}  height  height of the rectangle's bottom-right corner
/// @param {int}  colour  colour of the rectangle
/// @param {number}  alpha  Alpha value of the rectangle
function draw_rectangle_solid(_x/*:number*/, _y/*:number*/, _width/*:number*/, _height/*:number*/, _colour/*:int*/, _alpha/*:number*/) {
	draw_sprite_ext(sprDot, 0, _x, _y, _width, _height, 0, _colour, _alpha);
}

/// @func draw_rectangle_width(x1, y1, x2, y2, width)
/// @desc Draws an outline of a rectangle with the lines at a given thickness
///
/// @param {number}  x1  x-position of the rectangle's top-left corner
/// @param {number}  y1  y-position of the rectangle's top-left corner
/// @param {number}  x2  x-position of the rectangle's bottom-right corner
/// @param {number}  y2  y-position of the rectangle's bottom-right corner
/// @param {number}  width  thickness of the lines
function draw_rectangle_width(_x1/*:number*/, _y1/*:number*/, _x2/*:number*/, _y2/*:number*/, _width/*:number*/) {
	draw_line_width(_x1, _y1, _x2, _y1, _width); // Top
	draw_line_width(_x1, _y2, _x2, _y2, _width); // Bottom
	draw_line_width(_x1, _y1, _x1, _y2, _width); // Left
	draw_line_width(_x2, _y1, _x2, _y2, _width); // Right
}

/// @func draw_rectangle_width_colour(x1, y1, x2, y2, width, col1, col2, col3, col4)
/// @desc Draws an outline of a rectangle with the lines at a given thickness & colour
///
/// @param {number}  x1  x-position of the rectangle's top-left corner
/// @param {number}  y1  y-position of the rectangle's top-left corner
/// @param {number}  x2  x-position of the rectangle's bottom-right corner
/// @param {number}  y2  y-position of the rectangle's bottom-right corner
/// @param {number}  width  thickness of the lines
/// @param {number}  col1  the colour of the top left corner
/// @param {number}  col2  the colour of the top right corner
/// @param {number}  col3  the colour of the bottom right corner
/// @param {number}  col4  the colour of the bottom left corner
function draw_rectangle_width_colour(_x1/*:number*/, _y1/*:number*/, _x2/*:number*/, _y2/*:number*/, _width/*:number*/, _col1/*:number*/, _col2/*:number*/, _col3/*:number*/, _col4/*:number*/) {
	draw_line_width_colour(_x1, _y1, _x2, _y1, _width, _col1, _col2); // Top
	draw_line_width_colour(_x1, _y2, _x2, _y2, _width, _col4, _col3); // Bottom
	draw_line_width_colour(_x1, _y1, _x1, _y2, _width, _col1, _col4); // Left
	draw_line_width_colour(_x2, _y1, _x2, _y2, _width, _col2, _col3); // Right
}

#endregion

#region Clipping Region (maybe not /*#as obsolete*/ /*#as I*/ thought)

/// @func draw_reset_clipping_region()
/// @desc Resets the clipping region defined using `draw_set_clipping_region`
function draw_reset_clipping_region() {
	gpu_set_stencil_enable(false);
}

/// @func draw_set_clipping_region(x, y, width, height, invert)
/// @desc Sets up a clipping region where drawing can only occur within the bounds specified
function draw_set_clipping_region(_x, _y, _width, _height, _invert = false) {
	// Enable the stencil buffer, and set the whole region to a value of 8
	gpu_set_stencil_enable(true);
	draw_clear_stencil(8);
	
	// Draw a rectangle to "carve out" a region from the stencil
	gpu_set_stencil_func(cmpfunc_always);
	gpu_set_stencil_pass(stencilop_zero);
	gpu_set_colorwriteenable(false, false, false, false);
	draw_rectangle(_x, _y, _x + _width, _y + _height, false);
	gpu_set_colorwriteenable(true, true, true, true);
	
	// Now set the stencil to only allow drawing within the carved out region
	// (or outside it, if set to invert)
	gpu_set_stencil_ref(4);
	gpu_set_stencil_func(_invert ? cmpfunc_lessequal : cmpfunc_greaterequal);
	gpu_set_stencil_pass(stencilop_replace);
}

#endregion

#region Text Align

/// @func draw_reset_text_align()
/// @desc Resets text alginment to its defaults
function draw_reset_text_align() {
	draw_set_text_align(fa_left, fa_top);
}

/// @func draw_set_text_align(halign, valign)
/// @desc Sets the alignment of all future text draws
///
/// @param {horizontal_alignment}  halign  horizontal alignment
/// @param {vertical_alignment}  valign  vertical alignment
function draw_set_text_align(_halign, _valign) {
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

#endregion

#region Colours

/// @func colour_normalize(colour)
/// @desc Converts a colour into a normalized array, where each colour channel is mapped from [0, 255] to [0, 1]
///
/// @param {int}  colour  The colour to normalize
///
/// @returns {ColourChannels}  The normalized colour
function colour_normalize(_colour) {
	return [
		colour_get_red(_colour) / 255,
		colour_get_green(_colour) / 255,
		colour_get_blue(_colour) / 255,
	];
}

/// @func colour_shift_hue(colour, shift)
/// @desc Shifts the hue of the given colour
function colour_shift_hue(_colour, _shift) {
	var _hue = colour_get_hue(_colour),
		_sat = colour_get_value(_colour),
		_val = colour_get_value(_colour);
	_hue = modf(_hue + _shift, 256);
	return make_colour_hsv(_hue, _sat, _val);
}

/// @func draw_reset_colour()
/// @desc Resets text colour to its defaults
function draw_reset_colour() {
	draw_set_colour(c_white);
}

/// @func make_colour_channels(red, green, blue)
/// @desc Generates a new colour given the RGB channels, each in a normalized range [0-1]
///
/// @param {number}  red  The red component of the colour
/// @param {number}  green  The green component of the colour
/// @param {number}  blue  The blue component of the colour
///
/// @returns {int}  The resulting colour
function make_colour_channels(_red, _green, _blue) {
	return make_color_rgb(_red * 255, _green * 255, _blue * 255);
}

/// @func multiply_colours(colour_1, colour_2)
/// @desc Generates a new colour by multiplying the channels of the two given colours
///
/// @param {int}  colour_1
/// @param {int}  colour_2
function multiply_colours(_col1, _col2) {
	return make_colour_channels(
		(colour_get_red(_col1) / 255) * (colour_get_red(_col2) / 255),
		(colour_get_green(_col1) / 255) * (colour_get_green(_col2) / 255),
		(colour_get_blue(_col1) / 255) * (colour_get_blue(_col2) / 255)
	);
}

#endregion

#region American Versions (no u)

#macro color_normalize colour_normalize
#macro color_shift_hue colour_shift_hue
#macro draw_rectangle_width_color draw_rectangle_width_colour
#macro draw_reset_color draw_reset_colour
#macro make_color_channels make_colour_channels
#macro multiply_colors multiply_colours

#endregion
