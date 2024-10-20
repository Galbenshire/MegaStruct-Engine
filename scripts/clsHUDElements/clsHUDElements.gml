/// @func HUDElement()
/// @desc Represents a graphic intended to appear on-screen as a HUD element
function HUDElement() constructor {
	/// -- draw(x, y)
	/// Draws the HUD element onto the screen
	///
	/// @param {number}  x  x-position to draw at
	/// @param {number}  y  y-position to draw at
    static draw = function(_x, _y) {
        //...
    };
    
    /// -- get_height()
	/// Gets the total height of this HUD element
	///
	/// @returns {int}  hieght, in pixels
    static get_height = function() {
		return 0;	
    };
    
    /// -- get_width()
	/// Gets the total width of this HUD element
	///
	/// @returns {int}  width, in pixels
    static get_width = function() {
		return 0;	
    };
}

/// @func HUDElement_Boss(max_health, palette)
/// @desc Represents the healthbar of a boss.
function HUDElement_Boss(_maxHealth, _palette) : HUDElement() constructor {
	healthpoints = _maxHealth;
	
	paletteBars = __init_healthbar_palettes(_maxHealth, _palette); /// @is {array<PaletteTwoTone>}
	paletteBG = $000000;
	
    static draw = function(_x, _y) {
		if (healthpoints <= 0)
			self.__draw_healthbar_empty(_x, _y);
		else if (healthpoints <= FULL_HEALTHBAR)
			self.__draw_healthbar_one_bar_left(_x, _y);
		else
			self.__draw_healthbar_layered(_x, _y, floor(healthpoints / FULL_HEALTHBAR));
    };
    static get_height = function() /*=>*/ {return 56};
    static get_width = function() /*=>*/ {return 8};
    
    // Private Functions
    
    /// -- __draw_healthbar_empty(x, y)
	/// Draws an empty healthbar. For when the boss has no health left.
    static __draw_healthbar_empty = function(_x, _y) {
		draw_mm_healthbar(_x, _y, 0, [ 0, 0, paletteBG ], [ 0, 0, 1 ]);
    };
    
    /// -- __draw_healthbar_layered(x, y, index)
	/// Draws a layered healthbar. For when the boss has more than one bar worth of health.
    static __draw_healthbar_layered = function(_x, _y, _index) {
		var _fullBarPalette = [ paletteBars[_index - 1][PaletteTwoTone.primary], paletteBars[_index - 1][PaletteTwoTone.secondary], paletteBG ];
		draw_mm_healthbar(_x, _y, FULL_HEALTHBAR, _fullBarPalette);
		
		var _relativeHealth = healthpoints - FULL_HEALTHBAR * _index;
		if (_relativeHealth <= 0)
			return;
		
		var _partialBarPalette = [ paletteBars[_index][PaletteTwoTone.primary], paletteBars[_index][PaletteTwoTone.secondary], 0 ];
		draw_mm_healthbar(_x, _y, _relativeHealth, _partialBarPalette, [1, 1, 0]);
    };
    
    /// -- __draw_healthbar_one_bar_left(x, y)
	/// Draws a single healthbar. For when the boss only has one bar worth of health.
    static __draw_healthbar_one_bar_left = function(_x, _y) {
		var _fullPalette = [ paletteBars[0][PaletteTwoTone.primary], paletteBars[0][PaletteTwoTone.secondary], paletteBG ];
		draw_mm_healthbar(_x, _y, healthpoints, _fullPalette);
    };
    
    /// -- __init_healthbar_palettes()
	/// Sets up the palette for each bar of health the boss has
    static __init_healthbar_palettes = function(_health, _initialPalette) {
		var _bars = max(1, ceil(_health / FULL_HEALTHBAR)),
			_barPalettes = array_create(_bars);
		
		for (var i = 0; i < _bars; i++) {
			_barPalettes[i] = [ _initialPalette[PaletteTwoTone.primary], _initialPalette[PaletteTwoTone.secondary] ];
			_initialPalette[PaletteTwoTone.primary] = colour_shift_hue(_initialPalette[PaletteTwoTone.primary], 32);
			_initialPalette[PaletteTwoTone.secondary] = colour_shift_hue(_initialPalette[PaletteTwoTone.secondary], 32);
		}
		
		return _barPalettes;
    };
}

/// @func HUDElement_Player()
/// @desc Represents the player's stats.
function HUDElement_Player() : HUDElement() constructor {
	// Player Health
	healthpoints = FULL_HEALTHBAR;
    healthPalette = [ $A8D8FC, $FFFFFF, $000000 ]; /// @is {PaletteThreeTone}
    
    // Player Weapon Ammo
    weaponID = WeaponType.BUSTER;
    ammo = FULL_HEALTHBAR;
    ammoVisible = false;
    ammoPalette = [ $EC7000, $F8B838, $000000 ]; /// @is {PaletteThreeTone}
    
    // Implementing the virtual functions
    static draw = function(_x, _y) {
        draw_mm_healthbar(_x + 8, _y, healthpoints, healthPalette);
        if (ammoVisible)
            draw_mm_healthbar(_x, _y, ammo, ammoPalette);
    };
    static get_height = function() /*=>*/ {return 56};
    static get_width = function() /*=>*/ {return 16};
    
    // Other Functions
    
    /// -- assign_weapon(weapon)
	/// Tells the HUD element to use the specified weapon for the ammo bar
	/// Various ammo-related variables will be updated accordingly
    static assign_weapon = function(_weapon) {
		if (is_undefined(_weapon)) {
			ammoVisible = false;
			return;
		}
		
		weaponID = _weapon.id;
		ammoVisible = !_weapon.has_flag(WeaponFlags.NO_AMMO);
		ammo = _weapon.ammo;
    };
}
