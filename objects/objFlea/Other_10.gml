/// @description Init Palette
/// @init

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Red": _colour = $5800E4; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour)) {
    palette = new ColourPalette([ _colour ], [ $FF7800 ]);
    onDraw = method(id, cbkOnDraw_colourReplacer);
}