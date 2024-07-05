/// @func FrameAnimationPlayer()
/// @desc A frame-based animation system
function FrameAnimationPlayer() constructor {
    #region Variables
	
	owner = other; /// @is {instance}
	
    currentAnimation = undefined; /// @is {FrameAnimation?}
    currentAnimationName = ""; // Name of the current animation
    currentFrame = 0; // Current frame of the current animation
    
    timeScale = new Fractional(1); /// @is {Fractional}
    animTimer = 0; // How long the current animation has been playing for.
    frameCounter = 0; // How many in-game frames the current frame lasts for. Affected by `timeScale`
    loops = 0;
    flag = "";
    
    animationMap = {}; /// @is {struct}
    
    __newFrame = false;
    __animFinished = false;
	
	#endregion
	
	#region Functions - Adding Animations
	
	/// @method add_animation(id, frames, duration, reset_frame)
	/// @desc Adds an animation to this player
	///
	/// @param {string}  id  Name of this animation. This will be its key in the animation map.
	/// @param {int}  frames  The number of frames in this animation.
	/// @param {number}  duration  How long each frame in this animation is.
	/// @param {int}  [reset_frame]  The frame to reset to once FrameAnimationPlayer has reached the end of this animation. Defaults to the first frame.
	///
	/// @returns {FrameAnimation}  The new animation.
    static add_animation = function(_id, _frames, _duration, _resetFrame = 0) {
        return add_animation_ext(_id, array_create(_frames, _duration), _resetFrame);
    };
    
    /// @method add_animation_ext(id, frame_durations, reset_frame)
	/// @desc Adds an animation to this player
	///
	/// @param {string}  id  Name of this animation. This will be its key in the animation map.
	/// @param {array<number>}  frame_durations  An array where its length will be how many frames the animation has, and each element is the duration of each frame.
	/// @param {int}  [reset_frame]  The frame to reset to once FrameAnimationPlayer has reached the end of this animation. Defaults to the first frame.
	///
	/// @returns {FrameAnimation}  The new animation.
	static add_animation_ext = function(_id, _framesDurations, _resetFrame = 0) {
		var _anim = new FrameAnimation();
		_anim.id = _id;
		_anim.owner = owner;
		_anim.frames = array_length(_framesDurations);
		_anim.frameDurations = _framesDurations;
		_anim.resetFrame = _resetFrame;
		
		animationMap[$ _anim.id] = _anim;
		
		return _anim;
    };
    
    /// @method add_animation_non_loop(id, frames, duration)
	/// @desc Adds a non-looping animation to this player
	///
	/// @param {string}  id  Name of this animation. This will be its key in the animation map.
	/// @param {int}  frames  The number of frames in this animation.
	/// @param {number}  duration  How long each frame in this animation is.
	///
	/// @returns {FrameAnimation}  The new animation.
	static add_animation_non_loop = function(_id, _frames, _duration) {
		return add_animation_ext(_id, array_create(_frames, _duration), -1);
    };
    
    /// @method add_animation_non_loop_ext(id, frame_durations)
	/// @desc Adds a non-looping animation to this player
	///
	/// @param {string}  id  Name of this animation. This will be its key in the animation map.
	/// @param {array<number>}  frame_durations  An array where its length will be how many frames the animation has, and each element is the duration of each frame.
	///
	/// @returns {FrameAnimation}  The new animation.
	static add_animation_non_loop_ext = function(_id, _framesDurations, _callback) {
		return add_animation_ext(_id, _framesDurations, -1);
    };
    
    #endregion
    
    #region Functions - Getters
	
	/// @method get_animation_duration(animation_name, ignore_time_scale)
	/// @desc Get the total duration of the specified animation, in frames
	///
	/// @param {string}  [animation_name]  The animation to get the duration of. Defaults to the current animation.
	/// @param {bool}  [ignore_time_scale]  Choose to ignore the player's current time scale. Defaults to false.
	///
	/// @returns {number}  The duration of the animation, in frames. Returns 0 if the animation could not be found
    static get_animation_duration = function(_animName = currentAnimationName, _ignoreScale = false) {
		if (!struct_exists(animationMap, _animName))
			return 0;
		
		var _duration = animationMap[$ _animName].get_total_duration();
		if (!_ignoreScale)
			_duration = (timeScale.value != 0) ? (_duration / timeScale.value) : infinity;
		
		return _duration;
    };
    
    /// @method get_animation_time(ignore_time_scale)
	/// @desc Gets how long the current animation has been running for
	///
	/// @param {bool}  [ignore_time_scale]  Choose to ignore the player's current time scale. Defaults to false.
	///
	/// @returns {number}  The timer's value
    static get_animation_time = function(_ignoreScale = false) {
        return animTimer * (_ignoreScale ? 1 : timeScale.value);
    };
	
	#endregion
	
	#region Functions - Setters
	
	/// @method set_time_scale(new_scale)
	/// @desc Sets the time scale of the animation player. Affects the currently playing animation.
	///
	/// @param {number}  new_scale  New time scale
    static set_time_scale = function(_new_scale) {
		timeScale.value	= _new_scale;
    };
	
	#endregion
	
	#region Updaing the current Animation
	
	/// @method update()
	/// @desc Runs through the current animation
    static update = function() {
        if (is_undefined(currentAnimation))
            return;
        
        timeScale.update();
        animTimer++;
        flag = "";
        
        var _ticks = abs(timeScale.integer);
        if (_ticks <= 0) {
			__process_animation();
			return;
        }
		repeat (_ticks)
			__tick();
    }
    
    /// @method __process_animation()
	/// @desc Goes throughs the current animations properties & callback.
    static __process_animation = function() {
		currentAnimation.run(currentFrame);
		if (__newFrame)
			flag = currentAnimation.get_flag(currentFrame);
		__newFrame = false;
    };
    
    /// @method __tick()
	/// @desc Represents a tick during the update function
    static __tick = function() {
		__process_animation();
        frameCounter--;
        
        if (frameCounter > 0)
			return;
		
		var _prevFrame = currentFrame;
		currentFrame++;
		
		if (currentFrame >= currentAnimation.frames) {
			if (currentAnimation.is_looping()) {
				currentFrame = currentAnimation.resetFrame;
				loops++;
			} else {
				__animFinished = true;
			}
		}
        
        var _remainder = frameCounter;
		reset_frame_counter();
		frameCounter += _remainder;
		
		__newFrame = (currentAnimation.get_frame(currentFrame) != _prevFrame) && !__animFinished;
    };
	
	#endregion
	
	#region Functions - Other
	
	/// @method is_animation_finished()
	/// @desc Checks if the current animation has finished.
	///		  Note: If the animation doesn't loop, it cannot "finish"
	///
	/// @returns {number}  Whether the animation has finished (true) or not (false)
	static is_animation_finished = function() {
		return __animFinished;
	};
	
	/// @method play(animation_name, force_play, time_scale)
	/// @desc Tells the animation player to start playing the given animation.
	///
	/// @param {string}  animation_name  The animation to play
	/// @param {bool}  [force_play]  If true, the animation will play from the beginning, even if it's already the current animation. Defaults to false.
	/// @param {number}  [time_scale]  Play the animation at a slower/faster speed than what's defined. Defaults to 1, regular speed.
    static play = function(_animName, _force = false, _timeScale = 1) {
        if (_animName == currentAnimationName && !_force)
            return;
        
        currentFrame = 0;
        loops = 0;
        animTimer = 0;
        timeScale.clear_all();
        timeScale.value = _timeScale;
        __newFrame = true;
        __animFinished = false;
        
        if (!struct_exists(animationMap, _animName)) {
			currentAnimation = undefined;
			currentAnimationName = "";
			return;
        }
        
        currentAnimation = animationMap[$ _animName];
        currentAnimationName = currentAnimation.id;
        reset_frame_counter();
    };
    
    /// @method reset_frame_counter()
	/// @desc Resets the `frameCounter` to the duration of the current frame.
    static reset_frame_counter = function() {
        frameCounter = currentAnimation.get_frame_duration(currentFrame);
    };
	
	#endregion
}

/// @func FrameAnimation()
/// @desc Holds data for a specific animation, that will be played by a FrameAnimationPlayer instance.
///		  No parameters here, since you're expected to create FrameAnimations via the `add` functions on the FrameAnimationPlayer.
function FrameAnimation() constructor {
	#region Variables
	
    id = "";
    owner = noone; /// @is {instance}
    frames = 0;
    resetFrame = 0; // -1 means the animation doesn't loop
    frameDurations = []; /// @is {array<number>}
    
    properties = []; /// @is {array<tuple<number, rest<any>>>}
    propertyCount = 0;
    
    callback = undefined; /// @is {function<int, void>?}
    
    flags = []; /// @is {array<string>}
    __hasFlags = false;
    
    #endregion
    
    #region Functions - Adding Properies/Callbacks
    
    /// @method add_callback(callback)
	/// @desc Adds a callback to this animation
	///
	/// @param {function<int, void>}  callback  The callback
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_callback = function(_callback) {
		callback = method(owner, _callback);
		return self;
    };
    
    /// @method add_flag(frame, flag)
	/// @desc Adds a flag on the specified frame of the animation
	///
	/// @param {int}  frame  Which frame of the animation to add the flag to. Will be clamped if out of range
	/// @param {string}  flag  The flag for the given frame
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_flag = function(_frame, _flag) {
		flags[get_frame(_frame)] = _flag;
		__hasFlags = true;
		return self;
    };
    
    /// @method add_property(property, values)
	/// @desc Adds a property of the owner for the animation to update
	///
	/// @param {string}  property  The name of the variable on the owner to adjust
	/// @param {array<any>}  values  The value `property` becomes on each frame of this animation
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_property = function(_property, _values) {
		var _valuesLength = array_length(_values);
		if (_valuesLength > frames) {
			array_resize(_values, frames);
		} else {
			while (_valuesLength < frames) {
				_values[_valuesLength] = _values[_valuesLength - 1];
				_valuesLength++;
			}
		}
		
		var _propertyData = array_concat([variable_get_hash(_property)], _values);
        array_push(properties, _propertyData);
        propertyCount++;
        return self;
    };
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_flag(frame)
	/// @desc Gets the flag set for the specific frame of the animation, if one is set.
	///
	/// @param {int}  frame  Which frame of the animation to check. Will be clamped if out of range
	///
	/// @returns {string}  The flag for the specified frame. Returns an empty string if the frame has no flag.
    static get_flag = function(_frame) {
		if (!__hasFlags)
			return "";
		
		var _flag = flags[get_frame(_frame)];
		return is_string(_flag) ? _flag : "";
    };
    
    /// @method get_frame(frame)
	/// @desc Gets a specific frame from the animation.
	///
	/// @param {int}  frame  Which frame of the animation to get. Will be clamped if out of range
	///
	/// @returns {int}  The index of the specified animation
    static get_frame = function(_frame) {
		return clamp(_frame, 0, frames - 1);
    };
    
    /// @method get_frame_duration(frame)
	/// @desc Get the duration of a specific frame of this animation, in in-game frames
	///
	/// @param {int}  frame  Which frame of the animation to check. Will be clamped if out of range
	///
	/// @returns {number}  The duration of the specified frame
    static get_frame_duration = function(_frame) {
		return frameDurations[get_frame(_frame)];
    };
    
    /// @method get_total_duration()
	/// @desc Get the total duration of this animation, in in-game frames
	///
	/// @returns {number}  The duration of this animation, in frames
    static get_total_duration = function() {
        return array_reduce(frameDurations, function(_prev, _curr, i) /*=>*/ {return _prev + _curr});
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method is_looping()
	/// @desc Returns whether this animation loops or not
	///
	/// @returns {bool}  Whether this animation can loop (true) or not (false)
    static is_looping = function() {
		return resetFrame >= 0;	
    };
    
    /// @method run(frame)
	/// @desc Updates the owner's properties, based on the current frame.
	///		  Also executes the callback, if it's set.
	///
	/// @param {int}  frame  Which frame of the animation to use. Will be clamped if out of range
    static run = function(_frame) {
		_frame = get_frame(_frame);
        for (var i = 0; i < propertyCount; i++)
            struct_set_from_hash(owner, properties[i][0], properties[i][_frame + 1]);
        
        if (!is_undefined(callback))
			callback(_frame);
    };
    
    #endregion
}
