/// @description Init Palette
/// @init

var _colours = [ $50DC58, $F8F8F8, $050505 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Green": /* Nothing */ break;
    case "Blue": _colours[0] = $FF7800; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourPalette(_colours);