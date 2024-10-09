/// @func Weapon()
/// @desc Represents a weapon that can be used by the player in-game.
function Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	// ID corresponding to the WeaponType enum
	static id = -1;
	
	// Colour palette for this weapon's icon. Also used for on the player
	static colours = array_create(PaletteWeapon.sizeof); /// @is {PaletteWeapon}
	
	// Possible attributes for this weapon (e.g No Ammo)
	static flags = 0;
	
	// Sprite of the weapon's icon (appears in the Pause Menu, and above the player's head when quick switching)
	static icon = sprWeaponIcons;
	
	// Which frame of the icon sprite to use
	static iconIndex = 0;
	
	// Name of the weapon
	static name = "";
	
	// Shortened version of the weapon name. Used in the Pause Menu.
	static shortName = "";
	
	#endregion
	
	#region Variables
	
	// How much ammo an instance of this weapon uses
	ammo = FULL_HEALTHBAR;
	
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
	
	/// @method get_colours()
	/// @desc Gets the colours of this weapon. Used to change the player's colours, for example.
	///
	/// @returns {PaletteWeapon}  A copy of this weapon's colours.
	static get_colours = function() {
		return variable_clone(colours);
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
		return (flags & _flag) > 0;
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
	switch (_id) {
		case WeaponType.BUSTER: return new Weapon_MegaBuster(); break;
		case WeaponType.BUSTER_PROTO: return new Weapon_ProtoBuster(); break;
		case WeaponType.BUSTER_BASS: return new Weapon_BassBuster(); break;
		case WeaponType.RUSH_COIL: return new Weapon_RushCoil(); break;
		case WeaponType.RUSH_JET: return new Weapon_RushJet(); break;
		case WeaponType.ICE_SLASHER: return new Weapon_IceSlasher(); break;
		case WeaponType.METAL_BLADE: return new Weapon_MetalBlade(); break;
		case WeaponType.SEARCH_SNAKE: return new Weapon_SearchSnake(); break;
		case WeaponType.SKULL_BARRIER: return new Weapon_SkullBarrier(); break;
	}
	
	return undefined;
}
