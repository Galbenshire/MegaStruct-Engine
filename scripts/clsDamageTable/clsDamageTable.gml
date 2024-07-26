/// @func DamageTable()
/// @desc Keeps a record of the damages an entity should receive from specific attacks
function DamageTable() constructor {
    owner = other; /// @is {prtEntity}
    sources = {}; /// @is {struct}
    
    /// @method add_source(object, damage)
    /// @desc Adds a source of damage
    ///
	/// @param {object}  object  The object index of the source of damage
	/// @param {number}  damage  The damage this object should inflict
    static add_source = function(_object, _damage) {
        sources[$ object_get_name(_object)] = _damage;
    };
    
    /// @method evaluate_damage(attacker, default_damage)
    /// @desc Given an attacker, this function will check how much damage it should be inflicting
    ///
	/// @param {object}  attacker  The attacking entity
	/// @param {number}  default_damage  Default damage if nothing is found in the table. Defaults to 1.
	///
	/// @returns {number}  The damage value after evaluation
    static evaluate_damage = function(_attacker, _defaultDamage = 1) {
        var _key = object_get_name(_attacker.object_index);
        return struct_exists(sources, _key) ? sources[$ _key] : _defaultDamage;
    };
    
    /// @method remove_source(object, damage)
    /// @desc Removes a source of damage from the table
    ///
	/// @param {object}  object  The object to remove from the table
    static remove_source = function(_object) {
        struct_remove(sources, object_get_name(_object));
    };
}
