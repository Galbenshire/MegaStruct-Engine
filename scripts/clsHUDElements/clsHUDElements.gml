/// @func PlayerHUD()
/// @desc Represents the player's stats on the HUD.
///       Specifically, their health & ammo.
function PlayerHUD() constructor {
    healthpoints = FULL_HEALTHBAR;
    healthPalette = [ $A8D8FC, $FFFFFF, $000000 ]; /// @is {PaletteHealthBar}
    
    ammo = FULL_HEALTHBAR;
    ammoPalette = [ $EC7000, $F8B838, $000000 ]; /// @is {PaletteHealthBar}
    ammoVisible = false;
    
    /// -- draw(x, y)
	/// Draws the Player's HUD onto the screen
	///
	/// @param {number}  x  x-position to draw at
	/// @param {number}  y  y-position to draw at
    static draw = function(_x, _y) {
        draw_mm_healthbar(_x + 8, _y, healthpoints, healthPalette);
        if (ammoVisible)
            draw_mm_healthbar(_x, _y, ammo, ammoPalette);
    };
}
