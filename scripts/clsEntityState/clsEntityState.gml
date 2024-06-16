/// @func EntityState(initial_state, execute_enter)
/// @desc A wrapper for a SnowState instance with features common for a game entity
///
/// @param {string}  initial_state  Initial state for the state machine
/// @param {bool}  [execute_enter]  Whether to execute the "enter" event for the initial state (true) or not (false) [Default: true]
function EntityState(_initState, _execEnter = true) constructor {
    #region Variables
    
    timer = 0;
    __state = new SnowState(_initState, _execEnter, other);
    
    #endregion
    
    #region Entity State Functions
    
    static has_just_changed = function() {
        return timer < 0;  
    };
    
    static posttick = function() {
        __state.posttick();
    };
    
    static tick = function() {
        __state.tick();
    };
    
    static update_timer = function() {
        timer++;
    };
    
    #endregion
    
    #region Wrapper Functions into SnowState
    
    static add = function(_name, _struct = {}) {
        __state.add(_name, _struct);
        return self;
    };
    
    static add_child = function(_parent, _name, _struct = {}) {
        __state.add_child(_parent, _name, _struct);
        return self;
    };
    
    static change = function(_state, _leave = undefined, _enter = undefined, _data = undefined) {
        __state.change(_state, _leave, _enter, _data);
        timer = -1;
        return self;
    };
    
    static inherit = function() {
        __state.inherit();
        return self;
    };
    
    #endregion
}