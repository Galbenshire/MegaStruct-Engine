/// @func BossHUD()
/// @desc Represents the health of a boss on the HUD.
function BossHUD() constructor {
	healthpoints = 0; // Starts at 0. The boss will fill it up during their intro.
	healthPalette = [ [ $A8D8FC, $FFFFFF, $000000 ] ]; /// @is {array<PaletteHealthBar>}
	
	/// -- draw(x, y)
	/// Draws the Boss HUD onto the screen
	///
	/// @param {number}  x  x-position to draw at
	/// @param {number}  y  y-position to draw at
    static draw = function(_x, _y) {
        draw_mm_healthbar(_x, _y, healthpoints, healthPalette[0]);
    };
}

/// @func PlayerHUD()
/// @desc Represents the player's stats on the HUD.
///       Specifically, their health & ammo.
function PlayerHUD() constructor {
    healthpoints = FULL_HEALTHBAR;
    healthPalette = [ $A8D8FC, $FFFFFF, $000000 ]; /// @is {PaletteHealthBar}
    
    ammo = FULL_HEALTHBAR;
    ammoPalette = [ $EC7000, $F8B838, $000000 ]; /// @is {PaletteHealthBar}
    ammoVisible = false;
    ammoWeapon = WeaponType.BUSTER;
    
    /// -- assign_weapon(weapon)
	/// Tells the HUD element to use the specified weapon for the ammo bar
	/// Various ammo-related variables will be updated accordingly
    static assign_weapon = function(_weapon) {
		if (is_undefined(_weapon)) {
			ammoVisible = false;
			return;
		}
		
		ammoWeapon = _weapon.id;
		ammoVisible = !_weapon.has_flag(WeaponFlags.NO_AMMO);
		ammo = _weapon.ammo;
    };
    
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
