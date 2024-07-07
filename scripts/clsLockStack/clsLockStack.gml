/// @func LockStack()
/// @desc Represents a "stackable" boolean that can be "disabled" by multiple sources
///       In other words, if multiple sources
function LockStack() constructor {
    counter = 0;
    switches = []; /// @is {array<LockStackSwitch>}
    
    /// -- add_switch(lock_switch)
	/// Adds a lock switch into this stack
	///
	/// @param {LockStackSwitch}  lock_switch  The lock switch to add
    static add_switch = function(_lockSwitch) {
        array_push(switches, _lockSwitch);
        counter += (_lockSwitch.active);
    };
    
    /// -- remove_all_switches()
	/// Releases all locks currently in the stack
    static remove_all_switches = function() {
        counter = 0;
        switches = [];
    };
    
    /// -- remove_switch(lock_switch)
	/// Removes the specified lock switch from the stack
	///
	/// @param {LockStackSwitch}  lock_switch  The lock switch to remove
    static remove_switch = function(_lockSwitch) {
        var _index = array_get_index(switches, _lockSwitch);
        if (_index == NOT_FOUND)
			return;
        
        counter -= (_lockSwitch.active);
        array_delete(switches, _index, 1);
    };
    
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
		counter = array_reduce(switches, function(_prev, _curr, __) /*=>*/ {return _prev + _curr.active}, 0);
    };
}

/// @func LockStackSwitch(lock_stack)
/// @desc Represents a lock switch applied to a given LockStack
///		  It can be set as active to apply a lock to the stack
///
/// @param {LockStack}  [lock_stack]  The lock stack this switch applies to.
function LockStackSwitch(_lockStack) constructor {
    stack = undefined; /// @is {LockStack}
    active = false;
    
    /// -- activate()
	/// Activates this switch, locking its assigned stack
    static activate = function() {
		if (active || !is_assigned())
			return;
		active = true;
		stack.counter++;
    };
    
    /// -- assign_to_stack(lock_stack)
	/// Assigns this switch to the specified lock stack
	///
	/// @param {LockStack}  lock_stack  The lock stack to assign this switch to
    static assign_to_stack = function(_lockStack) {
		if (is_assigned())
			return;
		stack = _lockStack;
		stack.add_switch(self);
    };
    
    /// -- deactivate()
	/// Deactivates this switch, potentially unlocking its assigned stack
    static deactivate = function() {
		if (!active || !is_assigned())
			return;
		active = false;
		stack.counter--;
    };
    
    /// -- is_assigned()
	/// Checks if this switch has been assigned to a lock stack
	///
	/// @returns {bool}  Whether this switch is assigned (true) or not (false)
    static is_assigned = function() {
		return !is_undefined(stack);
    };
    
    /// -- remove_from_stack()
	/// Removes this switch from its assigned lock stack
    static remove_from_stack = function() {
		if (!is_assigned())
			return;
		stack.remove_switch(self);
		stack = undefined;
		active = false;
    };
    
    // - Initialize
    if (!is_undefined(_lockStack))
		assign_to_stack(_lockStack);
}
