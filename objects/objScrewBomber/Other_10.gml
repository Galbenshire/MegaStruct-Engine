/// @description Init Palette
/// @init

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red": /* Nothing */ break;
    case "Orange": _colour = $5878FF; break;
    case "Blue": _colour = $FF7800; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour)) {
	palette = new ColourPalette([ _colour ], [ $5800E4 ]);
	bulletPalette[0] = _colour;
    onDraw = method(id, cbkOnDraw_colourReplacer);
}