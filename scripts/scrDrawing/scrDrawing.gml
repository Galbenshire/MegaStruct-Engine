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
