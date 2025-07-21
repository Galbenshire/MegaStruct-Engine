/// @description Init Palette
/// @init

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Grey": _colour = $787878; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour)) {
    palette = new ColourPalette([ _colour ], [ $FF7800 ]);
    onDraw = method(id, cbkOnDraw_colourReplacer);
}