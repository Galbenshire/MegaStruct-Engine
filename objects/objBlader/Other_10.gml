/// @description Init Palette
if (!is_shader_supported(shdReplaceColour))
    exit;

var _colour = undefined;

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Green": /* Nothing */ break;
    case "Blue": _colour = $FF7800; break;
    case "Custom": _colour = customColour; break;
}

if (!is_undefined(_colour))
    palette = new ColourReplacer([ $50DC58 ], [ _colour ]);