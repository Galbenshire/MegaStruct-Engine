/// === SINGLETON ===
/// @func SignalBus()
/// @desc Handles the emitting of signals to any object that wants to listen.
///       A way for instances to listen to each other without coupling code.
///       (This would also be known as an Event Bus, but Events mean something else in GMS)
function SignalBus() constructor {
	ENFORCE_SINGLETON
	
    #region Variables
    
    signals = {}; /// @is {struct}
    
    #endregion

    #region Functions - Getters
    
    /// @method get_signal(name)
	/// @desc Gets a specific signal from the SignalBus' map.
	///
	/// @param {string}  name  Name of the signal to get
	///
	/// @returns {array<SignalListener>?}  The signal, and all its listeners. Returns `undefined` if the given signal doesn't exist.
    static get_signal = function(_name) {
        return signals[$ _name];
    };
    
    /// @method get_all_signal_names()
	/// @desc Gets the names of all active signals in the SignalBus
	///
	/// @returns {array<string>}  The names of all active signals
    static get_all_signal_names = function() {
        return struct_get_names(signals);
    };
    
    #endregion
    
    #region Functions - Connect/Disconnect
    
    /// @method connect_to_signal(signal_name, scope, callback, one_shot)
	/// @desc Connects an instance to a signal
	///
	/// @param {string}  signal_name  Name of the signal to connect to
	/// @param {instance|struct}  scope  The instance/struct the callback applies to
	/// @param {function<struct, void>}  callback  The function that will be called when this signal emits.
	/// @param {bool}  [one_shot]  If true, this listener will only be run once. Defaults to false.
	///
	/// @returns {SignalListener}  The listener that connects the instance to the Bus.
    static connect_to_signal = function(_signalName, _scope, _callback, _oneShot = false) {
        // New signal? Add it to our signal map first
        if (!struct_exists(signals, _signalName))
            struct_set(signals, _signalName, []);
        
        var _signal = get_signal(_signalName),
            _listener = new SignalListener(_signalName, _scope, _callback, _oneShot);
        array_push(_signal, _listener);
        
        return _listener;
    };
    
    /// @method disconnect_from_signal(listener)
	/// @desc Disconnects a SignalListener from its signal
	///
	/// @param {SignalListener}  listener  The SignalListener to disconnect
    static disconnect_from_signal = function(_listener) {
        var _signalName = _listener.signalName;
        
        // The signal this is listening to no longer exists?
        // That shouldn't be possible, but just incase, just delete the listener.
        if (!struct_exists(signals, _signalName)) {
            delete _listener;
            return;
        }
        
        var _signal = get_signal(_signalName),
            _index = array_get_index(_signal, _listener);
        
        if (_index != -1)
            array_delete(_signal, _index, 1);
        delete _listener;
        
        if (array_length(_signal) <= 0)
            struct_remove(signals, _signalName);
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method clear_all_signals()
	/// @desc Clears ALL signals of all of their listeners
    static clear_all_signals = function() {
        var _signalNames = get_all_signal_names(),
            _signalCount = array_length(_signalNames);
        
        for (var i = 0; i < _signalCount; i++)
            clear_signal(_signalNames[i]);
    };
    
    /// @method clear_signal(name)
	/// @desc Clears a signal of all its listeners
	///
	/// @param {string}  name  Name of the signal to clear
    static clear_signal = function(_name) {
        if (!struct_exists(signals, _name))
            return;
        
        var _signal = get_signal(_name),
            _listenerCount = array_length(_signal);
        
        for (var i = _listenerCount - 1; i >= 0; i--) {
            delete _signal[i];
            array_delete(_signal, i, 1);
        }
        
        struct_remove(signals, _name);
    };
    
    /// @method emit_signal(name, data)
	/// @desc Emits a signal, which all listeners attached will respond to
	///
	/// @param {string}  name  Name of the signal to emit
	/// @param {struct}  [data]  Optional data to pass along to the signal
    static emit_signal = function(_name, _data = {}) {
        //show_debug_message("Emitting Signal: {0}", _name);
        
        if (!struct_exists(signals, _name))
            return;
            
        var _signal = get_signal(_name),
            _listenerCount = array_length(_signal);
        
        for (var i = _listenerCount - 1; i >= 0; i--) {
            var _listener = _signal[i],
				_ownerExists = _listener.owner_exists();
            
            if (_ownerExists)
				_listener.callback(_data);
            
            if (!_ownerExists || _listener.oneShot) {
                delete _listener;
                array_delete(_signal, i, 1);
            }
        }
        
        if (array_length(_signal) <= 0)
            struct_remove(signals, _name);
    };
    
    /// @method prune_all_signals()
	/// @desc Removes any stale listeners still connected to all signals in the system
    static prune_all_signals = function() {
		var _signalNames = get_all_signal_names(),
            _signalCount = array_length(_signalNames);
        
        for (var i = 0; i < _signalCount; i++)
            prune_signal(_signalNames[i]);
    };
    
    /// @method prune_signal(name)
	/// @desc Removes any stale listeners still connected to the given signal
	///
	/// @param {string}  name  Name of the signal to prune
    static prune_signal = function(_name) {
		var _signal = get_signal(_name),
            _listenerCount = array_length(_signal);
        
        for (var i = _listenerCount - 1; i >= 0; i--) {
			var _listener = _signal[i];
            if (!_listener.owner_exists())
                disconnect_from_signal(_listener);
        }
    };
    
    #endregion
}

/// @func SignalListener(signal, owner, callback, one_shot)
/// @desc Represents an instance/struct listening to a specific signal
///
/// @param {string}  signal  Name of the signal
/// @param {instance|weak_reference}  owner  The instance (or struct) this listener belongs to
/// @param {function<struct, void>}  callback  Callback to perform upon hearing the signal
/// @param {bool}  [one_shot]  If true, this listener only functions once. Defaults to false.
function SignalListener(_signal, _owner, _callback, _oneShot = false) constructor {
	signalName = _signal; /// @is {string}
	
	ownerIsInstance = (instanceof(_owner) == "instance"); /// @is {bool}
    owner = ownerIsInstance ? _owner : weak_ref_create(_owner); /// @is {instance|weak_reference}
    
    callback = method(owner, _callback); /// @is {function<struct, void>}
    oneShot = _oneShot; /// @is {bool}
    
    /// @method owner_exists()
	/// @desc Checks if the owner of this SignalListener actually exists
	///
	/// @returns {bool}  If the owner exists (true) or not (false)
    static owner_exists = function() {
		// Use instance_exists if the owner is an instance.
		// Otherwise, it's a struct, so check if the struct ref still exists
		return ownerIsInstance ? instance_exists(owner) : weak_ref_alive(owner);
    };
}

/// @func signal_bus()
/// @desc Returns a static instance of SignalBus
///
/// @returns {SignalBus}  A reference to this SignalBus static.
function signal_bus() {
	static _instance = new SignalBus();
	return _instance;
}
