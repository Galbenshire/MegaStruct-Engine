/// @description Init Palette
/// @init

if (!is_shader_supported(shdReplaceColour))
    exit;

var _colours = [ $5800E4, $F8F8F8, $000000 ];

switch (colourPreset) {
    default: /* Nothing */ break;
    case "Red/White": /* Nothing */ break;
    
    case "Blue/White":
        _colours[0] = $FF7800;
        _colours[1] = $F8F8F8;
        break;
    
    case "Red/Orange":
        _colours[0] = $5800E4;
        _colours[1] = $40A4FF;
        break;
    
    case "Custom":
        _colours[0] = customColourPrimary;
        _colours[1] = customColourSecondary;
        break;
}

palette = new ColourReplacerPalette(_colours);