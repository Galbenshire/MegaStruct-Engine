/// @func LockStack()
/// @desc Represents a "stackable" boolean that can be "disabled" by multiple sources
///       In other words, if multiple sources
function LockStack() constructor {
    counter = 0;
    locks = []; /// @is {array<LockStackLock>}
    
    /// @method add_lock()
	/// @desc Adds a lock into this stack
	///
	/// @returns {LockStackLock}  The newly created lock
    static add_lock = function() {
        var _lock = new LockStackLock(); 
        array_push(locks, _lock);
        counter++;
        return _lock;
    };
    
    /// @method release_all_locks()
	/// @desc Releases all locks currently in the stack
    static release_all_locks = function() {
        counter = 0;
        locks = [];
    };
    
    /// @method release_lock(lock)
	/// @desc Releases the specified lock from the stack
	///
	/// @param {LockStackLock}  lock  The lock to release
	///
	/// @returns {undefined}
    static release_lock = function(_lock) {
        var _index = array_get_index(locks, _lock);
        if (_index != NOT_FOUND) {
            array_delete(locks, _index, 1);
            counter--;
        }
        return undefined;
    };
    
    /// @method is_locked()
	/// @desc Checks if the LockStack is currently locked
	///
	/// @returns {bool}  Whether the LockStack is locked (true) or not (false)
    static is_locked = function() {
        return (counter > 0);  
    };
}

/// @func LockStackLock()
/// @desc Represents a lock applied to a LockStack
function LockStackLock() constructor {
    assert(is_instanceof(other, LockStack), "LockStackLock() should only be created by an instance of LockStack()");
    
    stack = other; /// @is {LockStack}
    
    /// @method release()
	/// @desc Releases this lock from its specified stack
	///
	/// @returns {undefined}
    static release = function() {
        stack.release_lock(self);
        return undefined;
    };
}
