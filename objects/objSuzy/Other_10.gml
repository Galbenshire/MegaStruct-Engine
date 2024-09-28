/// @description Init Palette
/// @init

if (!is_shader_supported(shdReplaceColour))
    exit;

var _colours = [ $5800E4, $F8F8F8, $000000 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red": /* Nothing */ break;
    case "Orange": _colours[0] = $5878FF; break;
    case "Blue": _colours[0] = $FF7800; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourReplacerPalette(_colours);