/// @func PlayerLockPool()
/// @desc A variant of LockStack designed to lock the many actions a player can take
function PlayerLockPool() constructor {
	#region Variables
	
	switches = []; /// @is {array<PlayerLockPoolSwitch>}
	results = 0;
	__updateResults = false;
    
    #endregion
    
    #region Functions - Adding/Removing Switches
    
    /// -- add_switch(lock_switch)
	/// Adds a lock switch into this lockpool
	///
	/// @param {PlayerLockPoolSwitch}  lock_switch  The lock switch to add
    static add_switch = function(_lockSwitch) {
        array_push(switches, _lockSwitch);
        _lockSwitch.pool = self;
        __updateResults = true;
    };
    
    /// -- remove_all_switches()
	/// Releases all locks currently in the lockpool
    static remove_all_switches = function() {
		while (!array_empty(switches))
			self.remove_switch(switches[0]);
		results = 0;
		__updateResults = false;
    };
    
    /// -- remove_switch(lock_switch)
	/// Removes the specified lock switch from the lockpool
	///
	/// @param {PlayerLockPoolSwitch}  lock_switch  The lock switch to remove
    static remove_switch = function(_lockSwitch) {
        var _index = array_get_index(switches, _lockSwitch);
        if (_index != NOT_FOUND) {
			array_delete(switches, _index, 1);
			_lockSwitch.pool = undefined;
			__updateResults = true;
        }
    };
    
    #endregion
    
    #region Functions - Checking actions
    
    /// @method is_any_locked(...actions)
	/// @desc Checks if any of the specified player actions are currently locked
	///
	/// @param {int}  ...actions  The player actions to check
	///
	/// @returns {bool}  Whether any action is locked (true) or not (false)
    static is_any_locked = function() {
        for (var i = 0; i < argument_count; i++) {
            if (is_locked(argument[i]))
                return true;
        }
        return false;
    };
    
    /// @method is_locked(action)
	/// @desc Checks if the specified player action is currently locked
	///
	/// @param {int}  action  The player action to check
	///
	/// @returns {bool}  Whether the action is locked (true) or not (false)
    static is_locked = function(_action) {
		if (__updateResults)
			self.update_results();
		
        switch (_action) {
            case PlayerAction.MOVE_FULL:
                return is_locked(PlayerAction.MOVE_GROUND) && is_locked(PlayerAction.MOVE_AIR);
            case PlayerAction.TURN_FULL:
                return is_locked(PlayerAction.TURN_GROUND) && is_locked(PlayerAction.TURN_AIR);
            default:
                return bitmask_has_bit(results, 1 << _action);
        }
        return false; // Failsafe
    };
    
    #endregion
    
    #region Functions - Other
    
    /// -- update_results()
	/// Updates the lockpool's result value
    static update_results = function() {
		__updateResults = false;
		results = 0;
		
		var i = 0; repeat(array_length(switches)) {
			results |= (switches[i].actions * switches[i].active);
			i++;
		}
    };
    
    #endregion
}

/// @func PlayerLockPoolSwitch(lock_pool, ...initial_actions)
/// @desc Represents a lock switch applied to a PlayerLockPoolSwitch.
///		  It can be set as active to apply a lock to the pool.
///       It also holds a record of which player actions it is locking.
///
/// @param {PlayerLockPool?}  [lock_pool]  The lock stack this switch applies to. Optional.
/// @param {int}  [...initial_actions]  The initial player actions to add. Optional
function PlayerLockPoolSwitch(_lockPool) constructor {
	#region Variables
	
    pool = _lockPool; /// @is {PlayerLockPool}
    actions = 0;
    active = false;
    
    #endregion
    
    #region Functions - Activating/Deactivating
    
    /// -- activate()
	/// Activates this switch, locking its assigned lockpool
    static activate = function() {
		if (!active && self.is_assigned())
			pool.__updateResults = true;
		active = true;
    };
    
    /// -- deactivate()
	/// Deactivates this switch, potentially unlocking its assigned lockpool
    static deactivate = function() {
		if (active && self.is_assigned())
			pool.__updateResults = true;
		active = false;
    };
    
    #endregion
    
    #region Functions - Adding/Removing Actions
    
    /// -- add_actions(...actions)
	/// Adds a number of player actions for this switch to lock.
	///
	/// @param {int}  ...actions  The player actions to add
    static add_actions = function() {
		for (var i = 0; i < argument_count; i++) {
			switch (argument[i]) {
                case PlayerAction.MOVE_FULL:
                    __add_action(PlayerAction.MOVE_GROUND);
                    __add_action(PlayerAction.MOVE_AIR);
                    break;
                case PlayerAction.TURN_FULL:
                    __add_action(PlayerAction.TURN_GROUND);
                    __add_action(PlayerAction.TURN_AIR);
                    break;
                default:
                    __add_action(argument[i]);
                    break;
            }
		}
    };
    
    /// -- remove_actions(...actions)
	/// Removes a number of player actions from this switch.
	///
	/// @param {int}  ...actions  The player actions to remove
    static remove_actions = function() {
		for (var i = 0; i < argument_count; i++) {
			switch (argument[i]) {
                case PlayerAction.MOVE_FULL:
                    __remove_action(PlayerAction.MOVE_GROUND);
                    __remove_action(PlayerAction.MOVE_AIR);
                    break;
                case PlayerAction.TURN_FULL:
                    __remove_action(PlayerAction.TURN_GROUND);
                    __remove_action(PlayerAction.TURN_AIR);
                    break;
                    break;
                default:
                    __remove_action(argument[i]);
                    break;
            }
		}
    };
    
    /// -- __add_action(action)
	/// Adds a singular player action for this switch to be locking
    static __add_action = function(_action) {
		var _bit = (1 << _action);
		if (bitmask_has_bit(actions, _bit)) // Bit already set?
			return;
		
		actions = bitmask_set_bit(actions, _bit);
		if (active && self.is_assigned())
			pool.__updateResults = true;
    };
    
    /// -- __remove_action(action)
	/// Removes a singular player action from this switch
    static __remove_action = function(_action) {
		var _bit = (1 << _action);
		if (!bitmask_has_bit(actions, _bit)) // Bit not even set?
			return;
		
		actions = bitmask_unset_bit(actions, _bit);
		if (active && self.is_assigned())
			pool.__updateResults = true;
    };
    
    #endregion
    
    #region Functions - Assignment
    
    /// -- is_assigned()
	/// Checks if this switch has been assigned to a lockpool
	///
	/// @returns {bool}  Whether this switch is assigned (true) or not (false)
    static is_assigned = function() {
		return !is_undefined(pool);
    };
    
    /// -- unassign_from_pool()
	/// Removes this switch from its assigned lockpool
    static unassign_from_pool = function() {
		if (self.is_assigned())
			pool.remove_switch(self);
    };
    
    #endregion
    
    // - Initialize
    if (!is_undefined(pool))
		pool.add_switch(self);
	var _initActions = array_create(argument_count - 1);
	for (var i = 1; i < argument_count; i++)
		_initActions[i - 1] = argument[i]
	method_call(add_actions, _initActions);
}
