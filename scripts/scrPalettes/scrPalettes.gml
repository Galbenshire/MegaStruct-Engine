/// @func input_palette_player()
/// @desc Creates a copy of input colours used for the player object
///
/// @returns {PalettePlayer}
function input_palette_player() {
	var _palette/*:PalettePlayer*/ = array_create(PalettePlayer.sizeof);
	_palette[@PalettePlayer.primary] = $EC7000;
	_palette[@PalettePlayer.secondary] = $F8B838;
	_palette[@PalettePlayer.outline] = $9858F8;
	_palette[@PalettePlayer.skin] = $A8D8FC;
	_palette[@PalettePlayer.face] = $000000;
	_palette[@PalettePlayer.eyes] = $FFFFFF;
	
	return _palette;
}

/// @func input_palette_weapon()
/// @desc Creates a copy of input colours used for player weapons.
///       Typically for weapon icons
///
/// @returns {PaletteWeapon}
function input_palette_weapon() {
    var _palette/*:PaletteWeapon*/ = array_create(PaletteWeapon.sizeof);
    _palette[@PaletteWeapon.primary] = $EC7000;
	_palette[@PaletteWeapon.secondary] = $F8B838;
	
	return _palette;
}
