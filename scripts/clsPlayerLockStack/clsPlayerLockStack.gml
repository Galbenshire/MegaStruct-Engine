/// @func PlayerLockStack()
/// @desc A variant of LockStack designed to lock many actions a player can take
function PlayerLockStack() constructor {
    counters = array_create(PlayerAction.COUNT, 0); /// @is {array<int>}
    locks = []; /// @is {array<PlayerLockStackLock>}
    
    /// @method add_lock(...locks)
	/// @desc Adds a lock into this stack
	///
	/// @param {rest<int>}  ...locks  The player actions to lock
	///
	/// @returns {PlayerLockStackLock}  The newly created lock
    static add_lock = function() {
        var _lock = new PlayerLockStackLock(); 
        array_push(locks, _lock);
        
        for (var i = 0; i < argument_count; i++) {
            switch (argument[i]) {
                case PlayerAction.MOVE:
                    _lock.add_action(PlayerAction.MOVE_GROUND);
                    _lock.add_action(PlayerAction.MOVE_AIR);
                    break;
                case PlayerAction.TURN:
                    _lock.add_action(PlayerAction.TURN_GROUND);
                    _lock.add_action(PlayerAction.TURN_AIR);
                    break;
                default:
                    _lock.add_action(argument[i]);
                    break;
            }
        }
        
        return _lock;
    };
    
    /// @method release_all_locks()
	/// @desc Releases all locks currently in the stack
    static release_all_locks = function() {
        counters = array_create(PlayerAction.COUNT, 0);
        locks = [];
    };
    
    /// @method release_lock(lock)
	/// @desc Releases the specified lock from the stack
	///
	/// @param {PlayerLockStackLock}  lock  The lock to release
	///
	/// @returns {undefined}
    static release_lock = function(_lock) {
        var _index = array_get_index(locks, _lock);
        if (_index == NOT_FOUND)
            return;
        
        var _actionCount = array_length(_lock.actions);
        for (var i = 0; i < _actionCount; i++)
            counters[_lock.actions[i]]--;
        
        array_delete(locks, _index, 1);
        return undefined;
    };
    
    /// @method is_any_locked(...actions)
	/// @desc Checks if any of the specified player actions are currently locked
	///
	/// @param {rest<int>}  ...actions  The player actions to check
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
}

/// @func PlayerLockStackLock()
/// @desc Represents a lock applied to a PlayerLockStack.
///       It holds a record of which player actions it is locking.
function PlayerLockStackLock() constructor {
    assert(is_instanceof(other, PlayerLockStack), "PlayerLockStackLock() should only be created by an instance of PlayerLockStack()");
    
    stack = other; /// @is {LockStack}
    actions = []; /// @is {array<int>}
    
    /// @method add_action(action)
	/// @desc Adds a player action for this lock to... lock
	///
	/// @param {int}  action  The player action to add
    static add_action = function(_action) {
        array_push(actions, _action);
        stack.counters[_action]++;
    };
    
    /// @method release()
	/// @desc Releases this lock from its specified stack
	///
	/// @returns {undefined}
    static release = function() {
        stack.release_lock(self);
        return undefined;
    };
    
    /// @method remove_action(action)
	/// @desc Removes a player action for this lock
	///
	/// @param {int}  action  The player action to remove
    static remove_action = function(_action) {
        var _index = array_get_index(actions, _action);
        if (_index == NOT_FOUND)
            return;
        
        array_delete(actions, _index, 1);
        stack.counters[_action]--;
    };
}
