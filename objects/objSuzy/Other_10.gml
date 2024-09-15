/// @description Init Palette
if (!is_shader_supported(shdReplaceColour))
    exit;

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red": /* Nothing */ break;
    case "Orange": _colour = $5878FF; break;
    case "Blue": _colour = $FF7800; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour))
    palette = new ColourReplacerPalette([ $5800E4 ], [ _colour ]);