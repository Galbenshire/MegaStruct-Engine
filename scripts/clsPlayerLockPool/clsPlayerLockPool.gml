/// @func PlayerLockPool()
/// @desc A variant of LockStack designed to lock the many actions a player can take
function PlayerLockPool() constructor {
    counters = array_create(PlayerAction.COUNT, 0); /// @is {array<int>}
    switches = []; /// @is {array<PlayerLockPoolSwitch>}
    
    /// -- add_switch(lock_switch)
	/// Adds a lock switch into this lockpool
	///
	/// @param {PlayerLockPoolSwitch}  lock_switch  The lock switch to add
    static add_switch = function(_lockSwitch) {
        array_push(switches, _lockSwitch);
        
        if (!_lockSwitch.active)
			return;
        for (var i = 0; i < PlayerAction.COUNT; i++)
			counters[i] += (_lockSwitch.actions & (1 << i) > 0);
    };
    
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
        switch (_action) {
            case PlayerAction.MOVE:
                return is_locked(PlayerAction.MOVE_GROUND) || is_locked(PlayerAction.MOVE_AIR);
            case PlayerAction.TURN:
                return is_locked(PlayerAction.TURN_GROUND) || is_locked(PlayerAction.TURN_AIR);
            default:
                return (counters[_action] > 0);
        }
        return false; // Failsafe
    };
    
    /// -- remove_all_switches()
	/// Releases all locks currently in the lockpool
    static remove_all_switches = function() {
        counters = array_create(PlayerAction.COUNT, 0);
        switches = [];
    };
    
    /// -- remove_switch(lock_switch)
	/// Removes the specified lock switch from the lockpool
	///
	/// @param {PlayerLockPoolSwitch}  lock_switch  The lock switch to remove
    static remove_switch = function(_lockSwitch) {
        var _index = array_get_index(switches, _lockSwitch);
        if (_index == NOT_FOUND)
			return;
        
        array_delete(switches, _index, 1);
        
        if (!_lockSwitch.active)
			return;
        for (var i = 0; i < PlayerAction.COUNT; i++)
			counters[i] -= (_lockSwitch.actions & (1 << i) > 0);
    };
    
    /// -- update_counters()
	/// Updates the lockpool's counters
    static update_counters = function() {
		counters = array_create(PlayerAction.COUNT, 0);
		
		var _switchCount = array_length(switches);
		for (var i = 0; i < _switchCount; i++) {
			if (!switches[i].active)
				continue;
			
			for (var j = 0; j < PlayerAction.COUNT; j++)
				counters[j] += (switches[i].actions & (1 << j) > 0);
		}
    };
}

/// @func PlayerLockPoolSwitch(lock_pool, ...initial_actions)
/// @desc Represents a lock switch applied to a PlayerLockPoolSwitch.
///		  It can be set as active to apply a lock to the pool.
///       It also holds a record of which player actions it is locking.
///
/// @param {PlayerLockPool}  [lock_pool]  The lock stack this switch applies to. Optional.
/// @param {int}  [...initial_actions]  The initial player actions to add. Optional
function PlayerLockPoolSwitch(_lockPool) constructor {
    pool = undefined; /// @is {PlayerLockPool}
    actions = 0;
    active = false;
    
    /// -- activate()
	/// Activates this switch, locking its assigned lockpool
    static activate = function() {
		if (active || !is_assigned())
			return;
		active = true;
		
		for (var i = 0; i < PlayerAction.COUNT; i++) {
			if (actions & (1 << i) > 0)
				pool.counters[i]++;
		}
    };
    
    /// -- add_actions(...actions)
	/// Adds a number of player actions for this switch to lock.
	///
	/// @param {int}  ...actions  The player actions to add
    static add_actions = function() {
		for (var i = 0; i < argument_count; i++) {
			switch (argument[i]) {
                case PlayerAction.MOVE:
                    __add_action(PlayerAction.MOVE_GROUND);
                    __add_action(PlayerAction.MOVE_AIR);
                    break;
                case PlayerAction.TURN:
                    __add_action(PlayerAction.TURN_GROUND);
                    __add_action(PlayerAction.TURN_AIR);
                    break;
                default:
                    __add_action(argument[i]);
                    break;
            }
		}
    };
    
    /// -- assign_to_pool(lock_pool)
	/// Assigns this switch to the specified PlayerLockPool
	///
	/// @param {PlayerLockPool}  lock_pool  The lock pool to assign this switch to
    static assign_to_pool = function(_lockPool) {
		if (is_assigned())
			return;
		pool = _lockPool;
		pool.add_switch(self);
    };
    
    /// -- deactivate()
	/// Deactivates this switch, potentially unlocking its assigned lockpool
    static deactivate = function() {
		if (!active || !is_assigned())
			return;
		active = false;
		
		for (var i = 0; i < PlayerAction.COUNT; i++) {
			if (actions & (1 << i) > 0)
				pool.counters[i]--;
		}
    };
    
    /// -- is_assigned()
	/// Checks if this switch has been assigned to a lockpool
	///
	/// @returns {bool}  Whether this switch is assigned (true) or not (false)
    static is_assigned = function() {
		return !is_undefined(pool);
    };
    
    /// -- remove_actions(...actions)
	/// Removes a number of player actions from this switch.
	///
	/// @param {int}  ...actions  The player actions to remove
    static remove_actions = function() {
		for (var i = 0; i < argument_count; i++) {
			switch (argument[i]) {
                case PlayerAction.MOVE:
                    __remove_action(PlayerAction.MOVE_GROUND);
                    __remove_action(PlayerAction.MOVE_AIR);
                    break;
                case PlayerAction.TURN:
                    __remove_action(PlayerAction.TURN_GROUND);
                    __remove_action(PlayerAction.TURN_AIR);
                    break;
                default:
                    __remove_action(argument[i]);
                    break;
            }
		}
    };
    
    /// -- remove_from_pool()
	/// Removes this switch from its assigned lockpool
    static remove_from_pool = function() {
		if (!is_assigned())
			return;
		pool.remove_switch(self);
		pool = undefined;
		active = false;
    };
    
    /// -- __add_action(action)
	/// Adds a singular player action for this switch to be locking
    static __add_action = function(_action) {
		var _bit = (1 << _action);
		if (actions & _bit > 0) // Bit already set?
			return;
		
		actions |= _bit;
		if (active && is_assigned())
			pool.counters[_action]++;
    };
    
    /// -- __remove_action(action)
	/// Removes a singular player action from this switch
    static __remove_action = function(_action) {
		var _bit = (1 << _action);
		if (actions & _bit == 0) // Bit not even set?
			return;
		
		actions &= ~_bit;
		if (active && is_assigned())
			pool.counters[_action]--;
    };
    
    // - Initialize
    if (!is_undefined(_lockPool))
		assign_to_pool(_lockPool);
	var _initActions = [];
	for (var i = 1; i < argument_count; i++)
		array_push(_initActions, argument[i]);
	method_call(add_actions, _initActions);
}
