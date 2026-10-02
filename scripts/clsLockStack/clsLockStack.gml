/// @func LockStack()
/// @desc Represents a "stackable" boolean that can be "disabled" by multiple sources
///       In other words, if multiple sources are trying to disabled a boolean,
///		  they will not conflict with each other
function LockStack() constructor {
    #region Variables
	
	switches = []; /// @is {array<LockStackSwitch>}
    counter = 0;
    
	#endregion
    
    #region Functions - Adding/Removing Switches
	
	/// -- add_switch(lock_switch)
	/// Adds a lock switch into this stack
	///
	/// @param {LockStackSwitch}  lock_switch  The lock switch to add
    static add_switch = function(_lockSwitch) {
        array_push(switches, _lockSwitch);
        _lockSwitch.stack = self;
        counter += _lockSwitch.active;
    };
    
    /// -- remove_all_switches()
	/// Releases all locks currently in the stack
    static remove_all_switches = function() {
		while (!array_empty(switches))
			self.remove_switch(switches[0]);
        counter = 0;
    };
    
    /// -- remove_switch(lock_switch)
	/// Removes the specified lock switch from the stack
	///
	/// @param {LockStackSwitch}  lock_switch  The lock switch to remove
    static remove_switch = function(_lockSwitch) {
        var _index = array_get_index(switches, _lockSwitch);
        if (_index != NOT_FOUND) {
			array_delete(switches, _index, 1);
			_lockSwitch.stack = undefined;
			counter -= _lockSwitch.active;
        }
    };
	
	#endregion
	
	#region Functions - Other
	
	/// -- is_locked()
	/// Checks if the LockStack is currently locked
	///
	/// @returns {bool}  Whether the LockStack is locked (true) or not (false)
    static is_locked = function() {
		return (counter > 0);  
    };
	
	/// -- update_counter()
	/// Updates the lock stack's counter
    static update_counter = function() {
		counter = 0;
		var i = 0; repeat(array_length(switches)) {
			if (switches[i].active)
				counter++;
			i++;
		}
    };
	
	#endregion
}

/// @func LockStackSwitch(lock_stack)
/// @desc Represents a lock switch applied to a given LockStack
///		  It can be set as active to apply a lock to the stack
///
/// @param {LockStack}  [lock_stack]  The lock stack this switch applies to.
function LockStackSwitch(_lockStack) constructor {
	#region Variables
	
    stack = _lockStack; /// @is {LockStack}
    active = false;
    
    #endregion
    
    #region Functions
    
    /// -- activate()
	/// Activates this switch, locking its assigned stack
    static activate = function() {
		if (!active && self.is_assigned())
			stack.counter++;
		active = true;
    };
    
    /// -- deactivate()
	/// Deactivates this switch, potentially unlocking its assigned stack
    static deactivate = function() {
		if (active && self.is_assigned())
			stack.counter--;
		active = false;
    };
    
    /// -- is_assigned()
	/// Checks if this switch has been assigned to a lock stack
	///
	/// @returns {bool}  Whether this switch is assigned (true) or not (false)
    static is_assigned = function() {
		return !is_undefined(stack);
    };
    
    /// -- unassign_from_stack()
	/// Removes this switch from its assigned lock stack
    static unassign_from_stack = function() {
		if (self.is_assigned())
			stack.remove_switch(self);
    };
    
    #endregion
    
    // - Initialize
    if (self.is_assigned())
		stack.add_switch(self);
}
