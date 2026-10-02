/// @description Update Palette
if (!copyPlayerPalette || !instance_exists(global.player.body))
    exit;

var _playerColours = array_slice(global.player.body.get_palette(true), 0, 3);
palette.set_output_colours(_playerColours);