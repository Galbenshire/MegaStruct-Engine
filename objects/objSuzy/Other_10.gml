/// @description Init Palette
/// @init

var _colours = [ $5800E4, $F8F8F8, $000000 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red": /* Nothing */ break;
    case "Orange": _colours[0] = $5878FF; break;
    case "Blue": _colours[0] = $FF7800; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourPalette(_colours);