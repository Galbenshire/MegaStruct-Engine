/// @func draw_mm_healthbar(x, y, value, colours)
/// @desc Draws a Mega Man style health/ammo bar
///
/// @param {number}  x  x-position to draw the healthbar
/// @param {number}  y  y-position to draw the healthbar
/// @param {number}  value  How full to draw the bar. In a [0 - 28] range.
/// @param {PaletteHealthBar}  colours  The palette of the bar
function draw_mm_healthbar(_x, _y, _value, _colours) {
	_value = clamp(ceil(_value), 0, FULL_HEALTHBAR);
	
	var _offset = 2 * (FULL_HEALTHBAR - _value);
	draw_sprite_ext(sprHealthbar, 3, _x, _y, 1, FULL_HEALTHBAR, 0, _colours[PaletteHealthBar.background], 1);
	draw_sprite_ext(sprHealthbar, 2, _x, _y + _offset, 1, _value, 0, _colours[PaletteHealthBar.secondary], 1);
	draw_sprite_ext(sprHealthbar, 1, _x, _y + _offset, 1, _value, 0, _colours[PaletteHealthBar.primary], 1);
}

/// @func draw_mm_healthbar_horizontal(x, y, value, colours)
/// @desc Draws a Mega Man style health/ammo bar
///
/// @param {number}  x  x-position to draw the healthbar
/// @param {number}  y  y-position to draw the healthbar
/// @param {number}  value  How full to draw the bar. In a [0 - 28] range.
/// @param {PaletteHealthBar}  colours  The palette of the bar
function draw_mm_healthbar_horizontal(_x, _y, _value, _colours) {
	_value = clamp(ceil(_value), 0, FULL_HEALTHBAR);
	_x += FULL_HEALTHBAR * 2
	
	var _offset = 2 * (FULL_HEALTHBAR - _value);
	draw_sprite_ext(sprHealthbar, 3, _x, _y, 1, FULL_HEALTHBAR, -90, _colours[PaletteHealthBar.background], 1);
	draw_sprite_ext(sprHealthbar, 2, _x - _offset, _y, 1, _value, -90, _colours[PaletteHealthBar.secondary], 1);
	draw_sprite_ext(sprHealthbar, 1, _x - _offset, _y, 1, _value, -90, _colours[PaletteHealthBar.primary], 1);
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
// American?
#macro draw_rectangle_width_color draw_rectangle_width_colour

/// @func draw_reset_colour()
/// @desc Resets text colour to its defaults
function draw_reset_colour() {
	draw_set_colour(c_white);
}
// Burgers?
#macro draw_reset_color draw_reset_colour

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

/// @func multiply_colours(colour_1, colour_2)
/// @desc Generates a new colour by multiplying the channels of the two given colours
///
/// @param {int}  colour_1
/// @param {int}  colour_2
function multiply_colours(_col1, _col2) {
	return make_color_rgb(
		(colour_get_red(_col1) / 255) * (colour_get_red(_col2) / 255) * 255,
		(colour_get_green(_col1) / 255) * (colour_get_green(_col2) / 255) * 255,
		(colour_get_blue(_col1) / 255) * (colour_get_blue(_col2) / 255) * 255,
	);
}
// Wisconsin?
#macro multiply_colors multiply_colours
