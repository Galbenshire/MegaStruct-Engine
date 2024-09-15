/// @description Init Palette
if (!is_shader_supported(shdReplaceColour))
    exit;

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Blue": /* Nothing */ break;
    case "Red": _colour = $5800E4; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour))
    palette = new ColourReplacerPalette([ $FF7800 ], [ _colour ]);