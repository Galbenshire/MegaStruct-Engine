/// @description Init Palette
if (!is_shader_supported(shdReplaceColour))
    exit;

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Grey": _colour = $787878; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour))
    palette = new ColourReplacerPalette([ $FF7800 ], [ _colour ]);