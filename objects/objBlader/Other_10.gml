/// @description Init Palette
/// @init

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Green": /* Nothing */ break;
    case "Blue": _colour = $FF7800; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour)) {
    palette = new ColourPalette([ _colour ], [ $50DC58 ]);
    onDraw = method(id, cbkOnDraw_colourReplacer);
}