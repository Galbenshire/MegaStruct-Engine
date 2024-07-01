/// @func Weapon(id)
/// @desc Represents a weapon that can be used by the player in-game.
///
/// @param {int}  id  ID that corresponds to this weapon (from the `WeaponType` enum)
function Weapon(_id) constructor {
    #region Parameters
	
    id = _id; /// @is {int} Corresponds to the WeaponType enum
	colours = array_create(PaletteWeapon.sizeof); /// @is {PaletteWeapon}
	flags = 0; // Attributes for this weapon (e.g No Ammo)
	// - Icon
	icon = sprWeaponIcons; // (appears in the Pause Menu, and above the player's head when quick switching)
	iconIndex = 0; // Which frame of the sprite to use
	// - Name
	name = "";
	shortName = ""; // Shortened version. Used in the Pause Menu.
	// - Callbacks
	onTick = method(self, __template_onTick); /// @is {function<prtPlayer,void>}
	onEquip = method(self, __template_onEquip); /// @is {function<prtPlayer,void>}
	onUnequip = method(self, __template_onUnequip); /// @is {function<prtPlayer,void>}
	
	#endregion
	
	#region Instance Variables
	
	__prototype = undefined; /// @is {Weapon?}
	ammo = FULL_HEALTHBAR; /// @is {number}
	
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
		if (!is_copy()) {
			if (DEBUG_ENABLED)
				show_debug_message("Error: Trying to change the ammo of a master copy of a Weapon");
			return;
		}
		ammo = clamp(_value, 0, FULL_HEALTHBAR);
		return self;
	};
	
	/// @method set_icon(sprite, index)
	/// @desc Sets the icon for this weapon, and optionally which frame to use
	///
	/// @param {sprite}  sprite  The sprite of the icon
	/// @param {int}  [index]  Which frame of the sprite to use. Defaults to 0.
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_icon = function(_sprite, _index = 0) {
		icon = _sprite;
		iconIndex = _index;
		return self;
	};
	
	/// @method set_name(full_name, short_name)
	/// @desc Sets the name for this weapon.
	///       You can also set its shortened name, though it'll create that itself if you don't specify
	///
	/// @param {string}  full_name  The full name of this weapon
	/// @param {string}  [short_name]  The shortened name of this weapon. If not defined, one will be automatically created.
	///
	/// @returns {Weapon}  A reference to this struct. Useful for method chaining.
	static set_name = function(_name, _short) {
		name = _name;
		shortName = _short;
		
		if (is_undefined(shortName)) {
			var _space = string_pos(" ", name);
			shortName = _space
				? string_insert(".", string_delete(name, 2, _space - 1), 2)
				: name;
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
		if (!is_copy()) {
			if (DEBUG_ENABLED)
				show_debug_message("Error: Trying to change the ammo of a master copy of a Weapon");
			return;
		}
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
		var _result = flags & _flag;
		return flags & _flag > 0;
	};
	
	/// @method instantiate()
	/// @desc Creates a copy of this weapon
	///       This should only be done on a master copy of a Weapon
	///       (i.e. one from the global.weaponList array)
	static instantiate = function() {
		assert(!is_copy(), "Trying to instantiate a Weapon that has already itself been instanced");
		var _copy = variable_clone(self);
		_copy.__prototype = self;
		return _copy;
	};
	
	/// @method is_copy()
	/// @desc Checks if this weapon is a master copy or not
	///
	/// @returns {bool}  If this is a copy (true) or a master copy (false)
	static is_copy = function() {
		return !is_undefined(__prototype);
	};
	
	#endregion
	
	#region Callback Templates
	
	// These templates by themselves have no use.
	// There main use is to explain how these callbacks are called, & the parameters that make up them
	
	/// @method __template_onTick(player)
	/// Template for the onTick callback
	/// On every frame this weapon is equipped by a player, its onTick callback is called
	///
	/// @param {prtPlayer}  player  the player object that is using this weapon
	static __template_onTick = function(_player) {};
	
	/// @method __template_onEquip()
	/// Template for the onEquip callback
	/// A weapon's onEquip callback is called whenever a player switches into this weapon
	///
	/// @param {prtPlayer}  player  the player object that is equipping this weapon
	static __template_onEquip = function(_player) {};
	
	/// @method __template_onUnequip()
	/// Template for the onUnequip callback
	/// A weapon's onUnequip callback is called whenever a player switches out of this weapon
	///
	/// @param {prtPlayer}  player  the player object that is unequipping this weapon
	static __template_onUnequip = function(_player) {};
	
	#endregion
}
