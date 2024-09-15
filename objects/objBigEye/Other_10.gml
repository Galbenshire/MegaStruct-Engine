/// @description Init Palette
if (!is_shader_supported(shdReplaceColour))
    exit;

var _colours = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red/White": /* Nothing */ break;
    case "Blue/White": _colours = [ $FF7800, $F8F8F8 ]; break;
    case "Red/Orange": _colours = [ $5800E4, $40A4FF ]; break;
    case "Custom": _colours = [customColourPrimary, customColourSecondary]; break;
}

if (!is_undefined(_colours))
    palette = new ColourReplacerPalette([ $5800E4, $F8F8F8 ], _colours);