/// @func EntityState()
/// @desc A lightweight state machine, intended for use by the entities of this engine
///		  Inspired by SnowState, by Sohom Sahaun ( https://github.com/sohomsahaun/SnowState/wiki )
function EntityState() constructor {
	#region Constants (in spirit)
    
    /// Boolean to check if this shader works on the current system
	static VALID_EVENTS = ["enter", "tick", "posttick", "leave"];
    
    #endregion
    
    #region Variables
    
    owner = other;
    stateMap = {};
    currentState = undefined; /// @is {struct?}
    previousState = undefined; /// @is {struct?}
    timer = 0;
    substate = 0;
    
    __focusState = undefined; /// @is {string?}
    __tempEvent = undefined; /// @is {function<void>}
    
    #endregion
    
    #region Functions - Adding States
    
    /// @method add(state_name)
	/// @desc Adds a new state into this state machine
	///
	/// @param {string}  state_name  Name of the state
	///
	/// @returns {EntityState?}  A reference to this state machine. Returns `undefined` instead of an error prevents this state being added
    static add = function(_name) {
		if (!is_string(_name) || (_name == "")) {
			self.log_error($"Invalid state name (\"{_name}\" is not a non-empty string)");
			return undefined;
		}
		if (struct_exists(stateMap, _name))
			self.log($"\"{_name}\" was already defined. Replacing the previous definition.");
		
		var _struct = { __name: _name };
		for (var i = 0, n = array_length(VALID_EVENTS); i < n; i++)
			_struct[$ VALID_EVENTS[i]] = function() {};
		
		stateMap[$ _name] = _struct;
		__focusState = _name;
		return self;
    };
    
    /// @method set_event(event_name, event_func, state)
	/// @desc Sets the function for the specific event of a given state
	///
	/// @param {string}  event_name  Name of the event
	/// @param {function<void>}  event_func  Function corresponding to this event
	/// @param {string}  [state]  Name of the state to set this event for. Defaults to the one last added.
    static set_event = function(_event, _func, _state = __focusState) {
		if (!array_contains(VALID_EVENTS, _event)) {
			self.log_error($"Invalid event ({_event}) supplied for \"{_state}\"");
			return undefined;
		}
		
		stateMap[$ _state][$ _event] = method(owner, _func);
		return self;
    };
    
    #endregion
    
    #region Functions - Updating
    
    static change_state = function(_state, _leave = undefined, _enter = undefined) {
		if (!is_undefined(_leave) && !is_callable(_leave)) {
			self.log_error("Invalid value for \"leave_func\" in change(). Should be a function.");
			return undefined;
		}
		if (!is_undefined(_enter) && !is_callable(_enter)) {
			self.log_error("Invalid value for \"enter_func\" in change(). Should be a function.");
			return undefined;
		}
		
		// Leaving the current event
		if (!is_undefined(currentState)) {
			__tempEvent = currentState.leave;
			_leave ??= currentState.leave;
			_leave();
		}
		
		// Edit various values
		previousState = currentState;
		currentState = stateMap[$ _state];
		timer = -1;
        substate = 0;
        
        // Entering the new event
        if (!is_undefined(currentState)) {
			__tempEvent = currentState.enter;
			_enter ??= currentState.enter;
			_enter();
		}
		
		__tempEvent = undefined;
		return self;
    };
    
    /// @method change_substate(new_substate)
	/// @desc Changes the substate of the currently running state
	///
	/// @param {number}  new_substate  The new substate
	///
	/// @returns {EntityState}  A reference to this struct. Useful for method chaining.
    static change_substate = function(_newSubstate) {
		timer = -1;
        substate = _newSubstate;
        return self;
    };
    
    /// @method posttick()
	/// @desc Runs the `posttick` event on the current state
    static posttick = function() {
		currentState.posttick();	
    };
    
    /// @method run_current_event_function()
	/// @desc Executes the event function defined for the leave event of the current state (when overriding the leave event)
	///       or the enter event of the next state (when overriding the enter event).
	///       NOTE: This function is meant to be used only when the default leave/enter events are overridden in the .change() method.
    static run_current_event_function = function() {
		if (is_undefined(__tempEvent)) {
			self.log_error("Invalid call of \"run_current_event_function\"");
			return undefined;
		}
        __tempEvent();
    };
    
    /// @method tick()
	/// @desc Runs the `tick` event on the current state
    static tick = function() {
		currentState.tick();	
    };
    
    /// @method update_timer()
	/// @desc Updates the timer
    static update_timer = function() {
        timer++;
    };
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_current_state()
	/// @desc Gets the name of the current state
	///
	/// @returns {string}  The name of the current state. Empty if there is no current state.
    static get_current_state = function() {
		return is_undefined(currentState) ? "" : currentState.__name;	
    };
    
    /// @method get_previous_state()
	/// @desc Gets the name of the previous state
	///
	/// @returns {string}  The name of the previous state. Empty if there is no previous state.
    static get_previous_state = function() {
		return is_undefined(previousState) ? "" : previousState.__name;	
    };
    
    /// @method get_states()
	/// @desc Gets the names of every state in the state machine
	///
	/// @returns {array<string>}  An array of every state in the machine
    static get_states = function() {
		return struct_get_names(stateMap);	
    };
    
    #endregion
    
    #region Functions - Debugging
    
    static log = function(_msg) {
		show_debug_message($"[EntityState] {_msg}");
    };
    
    static log_error = function(_msg) {
		print_err($"[EntityState:Error] {_msg}");
    };
    
    #endregion
}
