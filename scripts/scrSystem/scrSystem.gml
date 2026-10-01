/// @func defer(type, function, delay, pause_mask, caller)
/// @desc Defers the given function to run at the given event/sub-event
///
/// @param {int}  type  When this deferred function should run (see the DeferType enum)
/// @param {function<instance,bool?>}  function  The function to run. Continues running if the function returns false.
/// @param {int}  [delay]  Delays the function by this many frames. Defaults to 0, no delay.
/// @param {int}  [pause_mask]  A bitmask detailing which types of pauses to listen for. Defaults to all non-weapon pauses.
/// @param {instance}  [caller]  The instance deferring this action. Defaults to the calling instance.
///
/// @returns {objDefer}  The deferred action
function defer(_type, _func, _delay = 0, _pauseMask = PauseType.GAMEPLAY, _caller = self) {
	var _depth = (instanceof(_caller) == "instance") ? _caller.depth : layer_get_depth(LAYER_SYSTEM);
	with (instance_create_depth(0, 0, _depth, objDefer)) {
		type = _type;
		caller = _caller;
		deferredAction = method(id, _func);
		pauseMask = _pauseMask;
		delay = _delay;
		__placedInEditor = false;
		
		return self;
	}
	return noone; // Failsafe
}

/// @func game_can_step(mask)
/// @desc Checks if the game is currently in a state where Step Events & Entity Ticks should occur
///
/// @param {int}  [mask]  A bitmask that determines which types of "pauses" should be checked for. Defaults to listening for game pauses, section switches, timescale & hitstun.
///
/// @returns {bool}  Whether the game should process Step Events (true) or not (false)
function game_can_step(_mask = PauseType.GAMEPLAY) {
	if (_mask == 0)
		return true;
	
	var _state = PauseType.PAUSEMENU * global.paused;
	_state += PauseType.TIMESCALE * (global.gameTimeScale.integer <= 0);
	_state += PauseType.HITSTUN * (global.hitStunTimer > 0);
	_state += PauseType.SECTION_SWITCH * global.switchingSections;
	return (_state & _mask) == 0;
};

/// @func health_restore_effect()
/// @desc Gets the object responsible for the health/ammo restore effect
///
/// @returns {objHealthRestoreEffect}
function health_restore_effect() {
	return instance_exists(objHealthRestoreEffect)
		? instance_nearest(0, 0, objHealthRestoreEffect)
		: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
}

/// @func hitstun_apply(duration)
/// @desc "Freezes" the game for the specified duration. Suitable for hit stun effects.
///
/// @param {bool}  duration  Duration of the hitstun
function hitstun_apply(_duration) {
	global.hitStunTimer = max(global.hitStunTimer, _duration);
}

/// @func hitstun_clear()
/// @desc Clears the hitstun timer, stopping any hitstun currently active
function hitstun_clear(_duration) {
	global.hitStunTimer = 0;
}

/// @func is_screen_fading()
/// @desc Checks if there is currently a screen fade in progress
///
/// @returns {bool} 
function is_screen_fading() {
	return instance_exists(objScreenFade);
}

/// @func screen_fade(config, caller)
/// @desc Performs a screen fade.
///		  Various actions can be performed at set parts of the fade.
///
/// @param {struct}  [config]  Defines various parameters of this screen fade.
///		The list of applicable parameters are as follows (all optional):
///		-- REGULAR PARAMS --
///		- fadeOutDuration: How long to fade out the screen
///		- fadeHoldDuration: How long to stay on the fade for
///		- fadeInDuration: How long to fade back into the game screen
///		- fadeColour: The colour of the fade. Defaults to black.
///		- fadeStep: Clamp the fade alpha to set intervals. Makes the fade appear more discreet.
///		- pauseMask: How the fade should react to pausing. Defaults to no effect.
///		- depthOffset: offets the fade's depth from the "Fader" layer
///		-- CALLBACKS --
///		- onFadeOutStart: Code to run at the start of fade out (basically right as the fade is created)
///		- onFadeOutEnd: Code to run at the end of fade out
///		- onFadeInStart: Code to run at the start of fade in
///		- onFadeInEnd: Code to run at the end of fade in, before the fade is destroyed
/// @param {instance}  [caller]  The instance to bind the callbacks to. Defaults to the calling instance.
///
/// @returns {objScreenFade}  The screen fade
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
