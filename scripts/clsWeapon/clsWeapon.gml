/// === MACROS relating to weapons ===

enum WeaponType {
	BUSTER,
	BUSTER_PROTO,
	BUSTER_BASS,
	RUSH_COIL,
	RUSH_JET,
	ICE_SLASHER,
	METAL_BLADE,
	SEARCH_SNAKE,
	SKULL_BARRIER,
	
	COUNT
}

enum WeaponFlags {
	// Ammo pickups have no effect, there's no ammo bar on the HUD, & Tanks ignore this weapon entirely
	NO_AMMO = 1 << 0,
	// Weapon is chargeable (e.g. the Mega Buster (if you're not basic))
	CHARGE = 1 << 1
}

/// @func Weapon()
/// @desc Represents a weapon that can be used by the player in-game.
function Weapon() constructor {
	#region Static Data (consistent across all weapon instances)
	
	// ID corresponding to the WeaponType enum
	static id = -1;
	
	// Possible attributes for this weapon (e.g No Ammo)
	static flags = 0;
	
	#endregion
	
	#region Variables (can differ on a per-instance basis)
	
	// The weapon icon
	icon = sprWeaponIcons;
	iconIndex = 0;
	iconColours = array_create(PaletteWeapon.sizeof); /// @is {PaletteWeapon} Also used to determine the player's colours
	
	// Naming the weapon
	name = "";
	shortName = ""; // Used in the Pause Menu.
	
	// Other
	ammo = FULL_HEALTHBAR;
	shotData = new WeaponShotBuilder();
	
	#endregion
	
	#region Callbacks
	
	/// @method on_tick(player)
	/// On every frame this weapon is equipped by a player, this callback is called
	///
	/// @param {prtPlayer}  player  The player object that is using this weapon
	static on_tick = function(_player) {
		//...
	};
	
	/// @method on_equip(player)
	/// This callback is called whenever a player switches into this weapon
	///
	/// @param {prtPlayer}  player  The player object that is equipping this weapon
	static on_equip = function(_player) {
		//...
	};
	
	/// @method on_unequip(player)
	/// This callback is called whenever a player switches out of this weapon
	///
	/// @param {prtPlayer}  player  The player object that is unequipping this weapon
	static on_unequip = function(_player) {
		//...
	};
	
	#endregion
	
	#region Functions - Getters
	
	/// @method get_icon_colours(copy)
	/// @desc Gets the colours of this weapon's icon. Also influences player colours when equipped.
	///
	/// @param {bool}  [copy]  Whether to return the colours as a reference (false, default) or a copy (true).
	///
	/// @returns {PaletteWeapon}  A copy of this weapon's colours.
	static get_icon_colours = function(_copy = false) {
		return _copy ? variable_clone(iconColours) : iconColours;
	};
	
	/// @method get_name(short_name, uppercase)
	/// @desc Gets the name of this weapon. Can specify for the shortened version instead.
	///       Can also have the name converted into uppercase.
	///
	/// @param {bool}  [short_name]  Whether to return the short version of the name. Defaults to false.
	/// @param {bool}  [uppercase]  Whether to return the name in uppercase or not. Defaults to false.
	///
	/// @returns {string}  The full name (or shortened name) for this weapon.
	static get_name = function(_short = false, _upper = false) {
		if (_short)
			return _upper ? string_upper(shortName) : shortName;
		else
			return _upper ? string_upper(name) : name;
	};
	
	#endregion
	
	#region Functions - Setters
	
	/// @method set_ammo(value, weapon)
	/// @desc Sets weapon ammo.
	///       Intended for use on copies of a weapon, as used by player objects.
	///
	/// @param {number}  value  The new ammo value
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_ammo = function(_value) {
		ammo = clamp(_value, 0, FULL_HEALTHBAR);
		return self;
	};
	
	/// @method set_icon_colours(colours, offset)
	/// @desc Sets multiple colours across the weapon's icon palette
	///
	/// @param {array<int>}  colours  The new colours to apply
	/// @param {int}  [offset]  At which index to start applying the new colours. Defaults to 0
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
    static set_icon_colours = function(_colours, _offset = 0) {
		for (var i = 0, n = array_length(_colours); i < n; i++) {
			if (i + _offset >= PaletteWeapon.sizeof)
				break;
			self.set_icon_colour_at(i + _offset, _colours[i]);
		}
		return self;
    };
	
	/// @method set_icon_colour_at(index, colour)
	/// @desc Sets a specific index in the weapon's icon palette to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set to
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_icon_colour_at = function(_index, _col) {
		if (!in_range(_index, 0, PaletteWeapon.sizeof)) {
			show_debug_message($"Weapon Warning: Trying to set an out-of-range index ({_index})");
			return self;	
		}
		
		iconColours[_index] = _col;
		return self;
	};
	
	/// @method set_icon(sprite, index)
	/// @desc Sets the weapon's icon sprite.
	///
	/// @param {sprite}  sprite  The new sprite for the icon
	/// @param {int}  [index]  The image index to use. Defaults to 0.
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_icon = function(_sprite, _index = 0) {
		icon = _sprite;
		iconIndex = _index;
		return self;	
	};
	
	/// @method set_name(name, short_name)
	/// @desc Sets the weapon's name.
	///
	/// @param {string}  name  The new name
	/// @param {string}  [short_name]  Shortened version of `name`. If undefined, one will be generated.
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_name = function(_name, _shortName) {
		name = _name;
		
		if (is_undefined(_shortName)) {
			shortName = _name;
			
			var _dot = string_pos(" ", shortName);
			if (_dot)
				shortName = string_insert(".", string_delete(shortName, 2, _dot - 1), 2);
		}
		
		return self;
	};
	
	#endregion
	
	#region Functions - Drawing
	
	/// @method draw_icon(x, y)
	/// @desc Draws the icon representing this weapon
	///
	/// @param {number}  x  horizontal position
	/// @param {number}  y  vertical position
	static draw_icon = function(_x, _y) {
	    draw_sprite(icon, iconIndex, _x, _y);
	};
	
	/// @method draw_icon_ext(x, y, xscale, yscale, angle, blend, alpha)
	/// @desc Draws the icon representing this weapon, with additional options
	///
	/// @param {number}  x  horizontal position
	/// @param {number}  y  vertical position
	/// @param {number}  xscale  horizontal scale
	/// @param {number}  yscale  vertical scale
	/// @param {number}  angle  angle to draw the icon at
	/// @param {number}  blend  colour blend to apply
	/// @param {number}  alpha  how transparent the icon should appear
	static draw_icon_ext = function(_x, _y, _xscale, _yscale, _angle, _blend, _alpha) {
		draw_sprite_ext(icon, iconIndex, _x, _y, _xscale, _yscale, _angle, _blend, _alpha);
	};
	
	#endregion
	
	#region Functions - Other
	
	/// @method change_ammo(value)
	/// @desc Change the ammo by a specific amount
	///
	/// @param {number}  value  How much to change ammo by
	///
	/// @returns {Player}  A reference to this struct. Useful for method chaining.
	static change_ammo = function(_value) {
		ammo = clamp(ammo + _value, 0, FULL_HEALTHBAR);
		return self;
	};
	
	/// @method has_flag(flag)
	/// @desc Checks if this weapon has the specified flag
	///
	/// @param {int}  flag  The flag to check for
	///
	/// @returns {bool}  If the weapon has the relevant flag (true) or not (false)
	static has_flag = function(_flag) {
		return bitmask_has_bit(flags, _flag);
	};
	
	/// @method reset_personalization()
	/// @desc Resets any personalizations that had been applied to this weapon
	static reset_personalization = function() {
		var _masterCopy = weapon_create_from_id(id);
		
		icon = _masterCopy.icon;
		iconIndex = _masterCopy.iconIndex;
		iconColours = variable_clone(_masterCopy.iconColours);
		name = _masterCopy.name;
		shortName = _masterCopy.shortName;
		
		delete _masterCopy;
	};
	
	#endregion
}

/// @func weapon_create_from_id(id)
/// @desc Generates a weapon instance
///
/// @param {int}  id  The ID of the weapon, corresponding to the WeaponType enum
///
/// @returns {Weapon}  A weapon instance
function weapon_create_from_id(_id) {
	return new global.weaponList[_id]();
}
