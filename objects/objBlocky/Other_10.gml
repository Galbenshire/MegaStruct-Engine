/// @description Init Palette
/// @init

if (!is_shader_supported(shdReplaceColour))
    exit;

var _colours = [ $FF7800, $F8F8F8, $050505 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Grey": _colours[0] = $787878; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourReplacerPalette(_colours);