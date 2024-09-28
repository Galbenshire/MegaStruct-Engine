/// @description Init Palette
/// @init

if (!is_shader_supported(shdReplaceColour))
    exit;

var _colours = [ $50DC58, $F8F8F8, $050505 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Green": /* Nothing */ break;
    case "Blue": _colours[0] = $FF7800; break;
    case "Custom": _colours[0] = customColour; break;
}

palette = new ColourReplacerPalette(_colours);