/// @func StateStacker()
/// @desc A stack-based state machine
///       In addition to your basic state machine functions (changing states),
///       You can also push a state, pausing the previous state until it is resumed.
function StateStacker(_defaultState, _enterNow = false) constructor {
	#region Variables
	
	owner = other;
    stateMap = {};
	stateStack = [];
	loggingEnabled = false;
	
    currentState = undefined; /// @is {StateStackerState?}
    previousState = undefined; /// @is {StateStackerState?}
	defaultState = undefined; /// @is {StateStackerState?}
	
	__defaultStateName = _defaultState;
	__defaultStateEnterNow = _enterNow;
	
	#endregion
	
	#region Functions - Getters
    
    /// @method get_current_state()
	/// @desc Gets the name of the current state
	///
	/// @returns {string}  The name of the current state. Empty if there is no current state.
    static get_current_state = function() {
		return is_undefined(currentState) ? "" : currentState.name;
    };
    
    /// @method get_previous_state()
	/// @desc Gets the name of the previous state
	///
	/// @returns {string}  The name of the previous state. Empty if there is no previous state.
    static get_previous_state = function() {
		return is_undefined(previousState) ? "" : previousState.name;	
    };
    
    /// @method get_substate()
	/// @desc Gets the substate of the current state
	///
	/// @returns {int}  The substate of the current state. `0` if there is no current state.
    static get_substate = function() {
		return is_undefined(currentState) ? 0 : currentState.substate;
    };
    
    /// @method get_state(name)
	/// @desc Gets a state by the name specified
	///
	/// @param {string}  state_name  Name of the state
	///
	/// @returns {StateStackerState?}  The state
    static get_state = function(_name) {
		return stateMap[$ _name];	
    };
    
    /// @method get_states()
	/// @desc Gets the names of every state in the state machine
	///
	/// @returns {array<string>}  An array of every state in the machine
    static get_states = function() {
		return struct_get_names(stateMap);	
    };
    
    /// @method get_timer()
	/// @desc Gets the time of the current state
	///
	/// @returns {int}  The time of the current state. `0` if there is no current state.
    static get_timer = function() {
		return is_undefined(currentState) ? 0 : currentState.timer;
    };
    
    #endregion
    
    #region Functions - Adding States
    
    /// @method add_state(state_name, event_data)
	/// @desc Adds a new state into this state machine
	///
	/// @param {string}  state_name  Name of the state
	/// @param {struct}  event_data  Various events for this state
	///
	/// @returns {StateStackerState?}  The newly created state. Returns `undefined` instead if an error prevents this state being added
    static add_state = function(_name, _events) {
		if (!is_string(_name) || _name == "")
			show_error($"Invalid state name (\"{_name}\" is not a non-empty string)", true);
		if (struct_exists(stateMap, _name))
			self.log($"\"{_name}\" was already defined. Replacing the previous definition.");
		
		var _state = new StateStackerState(_name, _events);
		stateMap[$ _name] = _state;
		
		if (_name == __defaultStateName && __defaultStateEnterNow) {
			defaultState = _state;
			self.change_state(defaultState.name);
		}
		
		return _state;
    };
    
    /// @method add_child_state(parent_state, child_state, event_data)
	/// @desc Adds a new state that inherits from an already defined state
	///
	/// @param {string}  parent_state  Name of the parent state
	/// @param {string}  child_state  Name of the child state
	/// @param {struct}  event_data  Various events for this state. Overrides any events inherited from the parent state.
	///
	/// @returns {StateStackerState?}  The newly created state. Returns `undefined` instead if an error prevents this state being added
    static add_child_state = function(_parentStateName, _childStateName, _childEvents) {
		if (!struct_exists(stateMap, _parentStateName))
			show_error($"Parent state \"{_parentStateName}\" is not present in the StateStacker", true);
		if (!is_string(_childStateName) || _childStateName == "")
			show_error($"Invalid state name (\"{_childStateName}\" is not a non-empty string)", true);
		if (struct_exists(stateMap, _childStateName))
			self.log($"\"{_childStateName}\" was already defined. Replacing the previous definition.");
		
		var _parentState = stateMap[$ _parentStateName],
			_childState = new StateStackerState(_childStateName, {});
		
		with (_childState) {
			other.stateMap[$ name] = self;
			super = _parentState.eventMap;
			struct_foreach(_childEvents, function(_eventName, _eventFunc) /*=>*/ { self.add_event(_eventName, _eventFunc); });
		}
		
		if (_childStateName == __defaultStateName && __defaultStateEnterNow) {
			defaultState = _childState;
			self.change_state(defaultState.name);
		}
		
		return _childState;
    };
    
    #endregion
	
	#region Functions - State Manipulation
    
    /// @method change_state(new_state, payload)
	/// @desc Changes state to the new one specified
	///
	/// @param {string}  [new_state]  Name of the new state to switch to. Defaults to whatever is assigned the default.
	/// @param {struct}  [payload]  Extra data to pass to the new state. Defaults to an empty payload.
	static change_state = function(_newState = __defaultStateName, _payload = {}) {
		if (!is_undefined(currentState))
			currentState.call_event("leave", [ _newState ]);
		
		previousState = currentState;
		currentState = stateMap[$ _newState];
		
		if (DEBUG_ENABLED && loggingEnabled)
			self.log($"(State Change) {self.get_previous_state()} -> {self.get_current_state()}");
		
		if (!is_undefined(currentState)) {
			if (!currentState.isInitialized) {
				currentState.call_event("init");
				currentState.isInitialized = true;
			}
			currentState.set_substate(0);
			currentState.call_event("enter", [ self.get_previous_state(), _payload ]);
		}
	};
	
	/// @method pop_all_states(end_state)
	/// @desc Pops all states currently on the stack
	///
	/// @param {string}  [end_state]  State to switch to at the end. Optional.
	/// @param {struct}  [payload]  Extra data to pass to the new state. Defaults to an empty payload.
	static pop_all_states = function(_endState, _payload = {}) {
		while (!array_empty(stateStack))
			self.pop_state();
		if (!is_undefined(_endState))
			self.change_state(_endState, _payload);
	}
	
	/// @method pop_state()
	/// @desc Changes the current state to one at the top of the stack
	static pop_state = function() {
		// If there's nothing in the stack,
		// treat this as a state change into the default state instead
		if (array_length(stateStack) <= 0) {
			self.change_state();
			return;
		}
		
		if (!is_undefined(currentState))
			currentState.call_event("leave", [ array_last(stateStack) ]);
		
		previousState = currentState;
		currentState = stateMap[$ array_pop(stateStack)];
		
		if (DEBUG_ENABLED && loggingEnabled)
			self.log($"(State Popped) {self.get_previous_state()} -> {self.get_current_state()}");
		
		if (!is_undefined(currentState))
			currentState.call_event("resume", [ self.get_previous_state() ]);
	};
	
	/// @method push_state(new_state, payload)
	/// @desc Changes state to the new one specified, pushing the prior state onto a stack
	///
	/// @param {string}  new_state  Name of the new state to switch to. Defaults to whatever is assigned the default.
	/// @param {struct}  [payload]  Extra data to pass to the new state. Defaults to an empty payload.
	static push_state = function(_newState = __defaultStateName, _payload = {}) {
		if (!is_undefined(currentState))
			currentState.call_event("pause", [ _newState ]);
		
		array_push(stateStack, currentState.name);
		previousState = currentState;
		currentState = stateMap[$ _newState];
		
		if (DEBUG_ENABLED && loggingEnabled)
			self.log($"(State Pushed) {self.get_previous_state()} -> {self.get_current_state()}");
		
		if (!is_undefined(currentState)) {
			if (!currentState.isInitialized) {
				currentState.call_event("init");
				currentState.isInitialized = true;
			}
			currentState.set_substate(0);
			currentState.call_event("enter", [ self.get_previous_state(), _payload ]);
		}
	};
	
	/// @method push_or_restart_state(new_state, payload)
	/// @desc Pushes the new state, or restarts it if it's already the currently active one
	///
	/// @param {string}  new_state  Name of the new state to switch to. Defaults to whatever is assigned the default.
	/// @param {struct}  [payload]  Extra data to pass to the new state. Defaults to an empty payload.
	static push_or_restart_state = function(_newState = __defaultStateName, _payload = {}) {
		if (self.get_current_state() == _newState)
			self.change_state(_newState, _payload);
		else
			self.push_state(_newState, _payload);
	};
	
	/// @method update_state()
	/// @desc Updates the timer of the currently running state
	///
	/// @returns {StateStacker}  A reference to this struct. Useful for method chaining.
    static update_state = function() {
        if (!is_undefined(currentState))
			currentState.timer++;
		return self;
    };
	
	#endregion
	
	#region Functions - Substates
    
    /// @method change_substate(shift)
	/// @desc Changes substate of the current state by a set amount
	///
	/// @param {number}  shift  How much to change the substate by
	///
	/// @returns {StateStacker}  A reference to this struct. Useful for method chaining.
    static change_substate = function(_shift) {
		if (!is_undefined(currentState))
			currentState.change_substate(_shift);
        return self;
    };
    
    /// @method set_substate(new_substate)
	/// @desc Sets substate of the current state
	///
	/// @param {number}  new_substate  The new substate
	///
	/// @returns {StateStacker}  A reference to this struct. Useful for method chaining.
    static set_substate = function(_newSubstate) {
		if (!is_undefined(currentState))
			currentState.set_substate(_newSubstate);
        return self;
    };
    
    #endregion
	
	#region Functions - Events
	
	/// @method call_event(event, args)
	/// @desc Calls a specific event on the currently running state
	///
	/// @param {string}  event  Name of the event
	/// @param {array<any>}  [args]  Arguments corresponding to this event
	///
	/// @returns {any}  The result of calling this event.
	static call_event = function(_eventName, _eventArgs = []) {
		if (!is_undefined(currentState))
			return currentState.call_event(_eventName, _eventArgs);
		return undefined;
	}
	
	/// @method tick(event)
	/// @desc Shortcut for calling a "tick" event on the currently running state
	///		  This event is assumed to have the following parameters:
	///		  - substate (int)
	///		  - timer (int)
	///		  - state data (this)
	///
	/// @param {string}  [event]  Name of the event. Defaults to "tick".
    static tick = function(_eventName = "tick") {
		var _curr = currentState;
        if (!is_undefined(_curr))
			_curr.call_event(_eventName, [ _curr.substate, _curr.timer ]);
    };
	
	#endregion
	
	#region Functions - Debugging
    
    static log = function(_msg) {
		show_debug_message($"[StateStacker] {_msg}");
    };
    
    static log_error = function(_msg) {
		print_err($"[StateStacker:Error] {_msg}");
    };
    
    #endregion
}

function StateStackerState(_name, _eventList) constructor {
	#region Variables
	
	name = _name;
	
	stateMachine = other; /// @is {StateStacker}
	owner = other.owner;
	
	eventMap = {};
	super = {}; // Inherited events
	
	substate = 0;
	timer = 0;
	
	isInitialized = false;
	
	#endregion
	
	#region Functions - Substates
    
    /// @method change_substate(shift)
	/// @desc Changes substate by a set amount
	///
	/// @param {number}  shift  How much to change the substate by
	///
	/// @returns {StateStackerState}  A reference to this struct. Useful for method chaining.
    static change_substate = function(_shift) {
		timer = -1;
        substate += _shift;
        return self;
    };
    
    /// @method set_substate(new_substate)
	/// @desc Sets substate
	///
	/// @param {number}  new_substate  The new substate
	///
	/// @returns {StateStackerState}  A reference to this struct. Useful for method chaining.
    static set_substate = function(_newSubstate) {
		timer = -1;
        substate = _newSubstate;
        return self;
    };
    
    #endregion
    
    #region Functions - Events
    
    /// @method add_event(name, func)
	/// @desc Adds an event into this state
	///
	/// @param {string}  name  Name of the event
	/// @param {function}  func  Function corresponding to this event
	///
	/// @returns {StateStackerState}  A reference to this struct. Useful for method chaining.
    static add_event = function(_eventName, _eventFunc) {
		if (struct_exists(eventMap, _eventName))
			stateMachine.log($"\"{_eventName}\" was already defined for \"{name}\". Replacing previous definition.");
		
        eventMap[$ _eventName] = method(owner, _eventFunc);
		return self;
    };
    
    /// @method call_event(event, args)
	/// @desc Calls a specific event
	///
	/// @param {string}  event  Name of the event
	/// @param {array<any>}  [args]  Arguments corresponding to this event
	///
	/// @returns {any}  The result of calling this event.
    static call_event = function(_eventName, _eventArgs = []) {
		var _event = eventMap[$ _eventName] ?? super[$ _eventName];
		if (is_undefined(_event))
			return undefined;
		
		var _fullArgs = array_concat(_eventArgs, [self]);
		return method_call(_event, _fullArgs);
    };
    
    #endregion
	
	#region Initialization
	
	struct_foreach(_eventList, function(_eventName, _eventFunc) /*=>*/ { self.add_event(_eventName, _eventFunc); });
	
	#endregion
}

// -- State Events
//
// - Init(state_data) - called when the state is entered for the first time
// - Enter(old_state, payload, state_data) - called when entering a new state
// - Leave(new_state, state_data) - called when exiting an old state
// - Tick(substate, timer, state_data) - called every frame while the current state is running
// - Pause(new_state, state_data) - called when a state is suspended as a new state is pushed on the stack
// - Resume(old_state, state_data) - called when a state is resumed as the state above it in the stack is popped
