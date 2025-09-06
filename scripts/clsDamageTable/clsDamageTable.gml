/// @func DamageTable()
/// @desc Keeps a record of the damages an entity should receive from specific attacks
function DamageTable() constructor {
    #region Variables
	
	owner = other; /// @is {prtEntity}
    entries = {}; /// @is {struct}
	
	#endregion
	
	#region Functions - Adding Entries
	
	/// @method add_entry(object, damage)
    /// @desc Adds a source of damage
    ///
	/// @param {object}  object  The object index of the source of damage
	/// @param {number}  damage  The damage this object should inflict
    static add_entry = function(_object, _damage) {
        entries[$ object_get_name(_object)] = _damage;
    };
	
	#endregion
	
	#region Functions - Removing Entries
    
    /// @method remove_all_entries(object)
    /// @desc Removes all sources of damage currently in the table
    static remove_all_entries = function() {
		delete entries;
		entries = {};
    };
    
    /// @method remove_entry(object)
    /// @desc Removes a source of damage from the table
    ///
	/// @param {object}  object  The object to remove from the table
    static remove_entry = function(_object) {
        struct_remove(entries, object_get_name(_object));
    };
    
    #endregion
    
    #region Functions - Evaluate
    
    /// @method evaluate_damage(attacker, default_damage)
    /// @desc Given an attacker, this function will check how much damage it should be inflicting
    ///
	/// @param {object}  attacker  The attacking entity
	/// @param {number}  default_damage  Default damage if nothing is found in the table. Defaults to 1.
	///
	/// @returns {number}  The damage value after evaluation
    static evaluate_damage = function(_attacker, _defaultDamage = 1) {
		var _attackObject = _attacker.object_index;
		
		// Traverse through the attacker's ancestry line until we find a valid source
		do {
			var _attackDamage = self.get_entry_damage(_attackObject, _attacker);
			if (!is_undefined(_attackDamage))
				return _attackDamage;
			
			_attackObject = object_get_parent(_attackObject);
		} until(_attackObject == -100);
		
		return _defaultDamage; // Nothing found? Use the default value.
    };
    
    /// @method get_entry_damage(object, instance)
    /// @desc Finds the damage value in the table for the given object
    static get_entry_damage = function(_object, _instance = noone) {
		return entries[$ object_get_name(_object)];
    }
    
    #endregion
}
