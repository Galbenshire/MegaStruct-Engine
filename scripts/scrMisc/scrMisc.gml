/// @func defer(type, function, delay, ignore_time_scale, ignore_pause, run_once, caller)
/// @desc Defers the given function to run at the given event/sub-event
///
/// @param {int}  type  When this deferred function should run (see the DeferType enum)
/// @param {function<instance,void>}  function  The function to run
/// @param {int}  [delay]  Delays the function by this many frames. Defaults to 0, no delay.
/// @param {bool}  [ignore_time_scale]  If true, the global time scale is ignored. Defaults to false.
/// @param {bool}  [ignore_pause]  If true, if runs even when the game is paused. Defaults to false.
/// @param {bool}  [run_once]  If true, the defer object is destroyed after running once. Defaults to true.
/// @param {instance}  [caller]  The instance deferring this action. Defaults to the calling instance.
///
/// @returns {objDefer}  The deferred action
function defer(_type, _func, _delay = 0, _ignoreTimeScale = false, _ignorePause = false, _runOnce = true, _caller = self) {
	var _params = {
		ignoreTimeScale: _ignoreTimeScale,
		ignorePause: _ignorePause,
		runOnce: _runOnce,
		delay: _delay
	};
	with (instance_create_depth(0, 0, _caller.depth, objDefer, _params)) {
		caller = _caller;
		deferredAction = method(id, _func);
		return self;
	}
	return noone; // Failsafe
}

/// @func is_html5()
/// @desc Checks if this game is running on HTML5
///
/// @returns {bool}  Whether the game is running on HTML5 (true) or not (false)
function is_html5() {
	return (os_browser != browser_not_a_browser) && (os_type != os_gxgames);
}

/// @func is_screen_fading()
/// @desc Checks if there is currently a screen fade in progress
///
/// @returns {bool} 
function is_screen_fading() {
	return instance_exists(objScreenFade);
}

/// @func is_shader_supported(shader)
/// @desc Checks to see if the given shader works on the current system.
///
/// @param {string|shader}  shader  The shader to check for. Supports either the name of the shader or its asset ID.
///
/// @returns {bool}  Whether this shader is supported (true) or not (false)
function is_shader_supported(_shader) {
	if (!global.shadersSupported)
		return false;
	
	var _shaderName = is_string(_shader) ? _shader : shader_get_name(_shader);
	if (!struct_exists(global.shadersCompiled, _shaderName))
		return false;
	
	return global.shadersCompiled[$ _shaderName];
}

/// @func queue_pause()
/// @desc Queues up a game pause at the beginning of the next game frame
function queue_pause() {
	objSystem.pause.pauseQueue = QUEUED_PAUSE;
}

/// @func queue_unpause()
/// @desc Queues up a game unpause at the beginning of the next game frame
function queue_unpause() {
	objSystem.pause.pauseQueue = QUEUED_UNPAUSE;
}

/// @func screen_fade()
/// @desc Performs a screen fade
function screen_fade(_config = {}) {
	if (struct_exists(_config, "onFadeOutStart"))
		_config.onFadeOutStart = method(self, _config.onFadeOutStart);
	if (struct_exists(_config, "onFadeOutEnd"))
		_config.onFadeOutEnd = method(self, _config.onFadeOutEnd);
	if (struct_exists(_config, "onFadeInStart"))
		_config.onFadeInStart = method(self, _config.onFadeInStart);
	if (struct_exists(_config, "onFadeInEnd"))
		_config.onFadeInEnd = method(self, _config.onFadeInEnd);
	
	instance_create_layer(0, 0, LAYER_FADER, objScreenFade, _config);
}
