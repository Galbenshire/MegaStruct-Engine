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
	var _depth = (instanceof(_caller) == "instance") ? _caller.depth : layer_get_depth(LAYER_SYSTEM);
	with (instance_create_depth(0, 0, _depth, objDefer, _params)) {
		type = _type;
		caller = _caller;
		deferredAction = method(id, _func);
		__placedInEditor = false;
		return self;
	}
	return noone; // Failsafe
}

/// @func game_can_step(ignore_time_scale, ignore_hitstun, ignore_pause)
/// @desc Checks if the game is currently in a state where Step Events & Entity Ticks should occur
///
/// @param {bool}  [ignore_time_scale]  If true, the effect of the game time scale is ignored. Defaults to false.
/// @param {bool}  [ignore_hitstun]  If true, the effect of the global hitstun is ignored. Defaults to false.
/// @param {bool}  [ignore_pause]  If true, ignore whether the game is paused. Defaults to false.
///
/// @returns {bool}  Whether the game should process Step Events (true) or not (false)
function game_can_step(_ignoreTimeScale = false, _ignoreHitstun = false, _ignorePause = false) {
	return (_ignorePause || !global.paused) && (_ignoreHitstun || global.hitStunTimer <= 0) && (_ignoreTimeScale || global.gameTimeScale.integer > 0);
}

/// @func health_restore_effect()
/// @desc Gets the object responsible for the health/ammo restore effect
///
/// @returns {objHealthRestoreEffect}
function health_restore_effect() {
	return instance_exists(objHealthRestoreEffect)
		? instance_nearest(0, 0, objHealthRestoreEffect)
		: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
}

/// @func is_screen_fading()
/// @desc Checks if there is currently a screen fade in progress
///
/// @returns {bool} 
function is_screen_fading() {
	return instance_exists(objScreenFade);
}

/// @func screen_fade(config)
/// @desc Performs a screen fade.
///		  Various actions can be performed at set parts of the fade.
///
/// @param {struct}  [config]  Defines various parameters of this screen fade.
///		The list of applicable parameters are as follows (all optional):
///		-- REGULAR PARAMS --
///		- fadeOutDuration: How long to fade out the screen
///		- fadeHoldDuration: How long to stay on the fade for
///		- fadeInDuration: How long to fade back into the game screen
///		- fadeColour: The colour of the fade. Defaults to black
///		- fadeStep: Clamp the fade alpha to set intervals. Makes the fade appear more discreet.
///		- ignoreTimeScale: If true, the fade is independant of the game screen.
///		-- CALLBACKS --
///		- onFadeOutStart: Code to run at the start of fade out (basically right as the fade is created)
///		- onFadeOutEnd: Code to run at the end of fade out
///		- onFadeInStart: Code to run at the start of fade in
///		- onFadeInEnd: Code to run at the end of fade in, before the fade is destroyed
function screen_fade(_config = {}, _caller = self) {
	if (struct_exists(_config, "onFadeOutStart"))
		_config.onFadeOutStart = method(_caller, _config.onFadeOutStart);
	if (struct_exists(_config, "onFadeOutEnd"))
		_config.onFadeOutEnd = method(_caller, _config.onFadeOutEnd);
	if (struct_exists(_config, "onFadeInStart"))
		_config.onFadeInStart = method(_caller, _config.onFadeInStart);
	if (struct_exists(_config, "onFadeInEnd"))
		_config.onFadeInEnd = method(_caller, _config.onFadeInEnd);
	
	instance_create_layer(0, 0, LAYER_FADER, objScreenFade, _config);
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
