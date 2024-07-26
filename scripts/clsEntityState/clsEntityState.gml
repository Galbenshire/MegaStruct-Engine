/// @func EntityState(initial_state, execute_enter)
/// @desc A wrapper for a SnowState instance with features common for a game entity
///
/// @param {string}  initial_state  Initial state for the state machine
/// @param {bool}  [execute_enter]  Whether to execute the "enter" event for the initial state (true) or not (false) [Default: true]
function EntityState(_initState, _execEnter = true) constructor {
    #region Variables
    
    timer = 0;
    substate = 0;
    __state = new SnowState(_initState, _execEnter, other);
    
    #endregion
    
    #region Entity State Functions
    
    /// @method change_substate(new_substate)
	/// @desc Changes the substate of the currently running state
	///
	/// @param {number}  new_substate  The new substate
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static change_substate = function(_newSubstate) {
        timer = 0;
        substate = _newSubstate;
        return self;
    };
    
    /// @method has_just_changed()
	/// @desc Returns if the state machine has just recently changed state
	///
	/// @returns {bool}  Whether the state machine recently changed state (true) or not (false)
    static has_just_changed = function() {
        return timer < 0;  
    };
    
    /// @method is_previous_state(state_name)
    /// @desc Checks if the state machine's previous state was the one specified
    ///
    /// @param {string}  state_name  Name of the state to check for
    ///
    /// @returns {bool}  Whether the previous state was the one given (true) or not (false)
    static is_previous_state = function(_stateName) {
		return __state.get_previous_state() == _stateName;
    };
    
    /// @method posttick()
	/// @desc Runs the `posttick` function of the current state
    static posttick = function() {
        __state.posttick();
    };
    
    /// @method tick()
	/// @desc Runs the `tick` function of the current state
    static tick = function() {
        __state.tick();
    };
    
    /// @method update_timer()
	/// @desc Updates the timer
    static update_timer = function() {
        timer++;
    };
    
    #endregion
    
    #region Wrapper Functions into SnowState
    
    /// @method add(state_name, state_struct)
	/// @desc Adds a new state to the state machine.
	///
	/// @param {string}  state_name  Name for the state
	/// @param {struct}  [state_struct]  State Struct containing the state events. Defaults to `{}`.
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static add = function(_name, _struct = {}) {
        __state.add(_name, _struct);
        return self;
    };
    
    /// @method add_child(parent_state_name, state_name, state_struct)
	/// @desc Adds a new state to the state machine, as a child to the parent state.
	///
	/// @param {string}  parent_state_name  Name for the parent state
	/// @param {string}  state_name  Name for the child state
	/// @param {struct}  [state_struct]  State Struct containing the state events. Defaults to `{}`.
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static add_child = function(_parent, _name, _struct = {}) {
        __state.add_child(_parent, _name, _struct);
        return self;
    };
    
    /// @method change(state_name, leave_func, enter_func, data)
	/// @desc Changes the state, performing the leave event for the current state and enter event for the next state by default.
	///       You can override the declared functions.
	///
	/// @param {string}  state_name  State to switch to
	/// @param {function}  [leave_func]  Custom leave event for the current state. For the default event, set it to `undefined`
	/// @param {function}  [enter_func]  Custom enter event for the next state. For the default event, set it to `undefined`
	/// @param {struct}  [data]  Data that can be passed as an argument in the custom leave and enter event functions. Defaults to `undefined`.
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static change = function(_state, _leave = undefined, _enter = undefined, _data = undefined) {
        __state.change(_state, _leave, _enter, _data);
        timer = -1;
        substate = 0;
        return self;
    };
    
    /// @method get_current_state()
	/// @desc Returns the current state the system is in.
	///
	/// @returns {string}  The current state
    static get_current_state = function() {
        return __state.get_current_state();
    };
    
    /// @method get_previous_state()
	/// @desc Returns the previous state the system was in.
	///
	/// @returns {string}  The previous state
    static get_previous_state = function() {
        return __state.get_previous_state();
    };
    
    /// @method inherit()
	/// @desc Executes the current event of the parent state. The functionality is similar to GameMaker's built-in event_inherited().
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static inherit = function() {
        __state.inherit();
        return self;
    };
    
    /// @method run_current_event_function()
	/// @desc Executes the event function defined for the leave event of the current state (when overriding the leave event)
	///       or the enter event of the next state (when overriding the enter event).
	///       NOTE: This function is meant to be used only when the default leave/enter events are overridden in the .change() method.
    static run_current_event_function = function() {
        (__state.event_get_current_function())();
    };
    
    #endregion
}