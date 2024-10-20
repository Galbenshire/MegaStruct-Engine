/// @description Init Palette
/// @init

var _colours = [ $FF7800, $F8F8F8, $050505 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Red": _colours[0] = $5800E4; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourPalette(_colours);