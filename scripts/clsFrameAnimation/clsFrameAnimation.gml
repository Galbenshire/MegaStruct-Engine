/// @func FrameAnimationPlayer()
/// @desc A frame-based animation system
function FrameAnimationPlayer() constructor {
    #region Variables
	
	owner = other; /// @is {instance}
	animationMap = {}; /// @is {struct}
	
    currentAnimation = undefined; /// @is {FrameAnimation?}
    currentAnimationName = ""; // Name of the current animation
    
    timeScale = 1;
    animTimer = 0; // How long the current animation has been playing for.
    frameCounter = 0; // Our progress in the current animation.
    loops = 0;
    
    __isNewFrame = false;
    __prevFrame = 0;
    __readFlags = [];
    __queue = []; // [ [ animation, time_scale ] ... ]
	
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
		var _anim = new FrameAnimation(_id, owner, _framesDurations, _resetFrame);
		animationMap[$ _id] = _anim;
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
	static add_animation_non_loop_ext = function(_id, _framesDurations) {
		return add_animation_ext(_id, _framesDurations, -1);
    };
    
    /// @method add_animation_single_frame(id)
	/// @desc Adds an animation with only one frame. Considered non-looping.
	///
	/// @param {string}  id  Name of this animation. This will be its key in the animation map.
	///
	/// @returns {FrameAnimation}  The new animation.
	static add_animation_single_frame = function(_id) {
		return add_animation_ext(_id, [2], -1);
    };
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_animation(animation_name)
	/// @desc Get the specified animation
	///
	/// @param {string}  [animation_name]  The name of the animation
	///
	/// @returns {FrameAnimation?}  The animation. Returns `undefined` if not found
    static get_animation = function(_animName) {
		return self.has_animation(_animName) ? animationMap[$ _animName] : undefined;
    };
	
	/// @method get_animation_duration(animation_name)
	/// @desc Get the total duration of the specified animation, in frames
	///
	/// @param {string}  [animation_name]  The animation to get the duration of. Defaults to the current animation.
	///
	/// @returns {number}  The duration of the animation, in frames. Returns 0 if the animation could not be found
    static get_animation_duration = function(_animName = currentAnimationName) {
		return self.has_animation(_animName) ? animationMap[$ _animName].duration : 0;
    };
    
    /// @method get_current_frame()
	/// @desc Gets the current frame of the animation currently running
	///
	/// @returns {int}  The current frame. Returns 0 if there is no animation playing.
    static get_current_frame = function() {
		return is_undefined(currentAnimation) ? 0 : currentAnimation.find_frame(frameCounter);
    };
	
	#endregion
	
	#region Functions - Setters
	
	/// @method set_time_scale(new_scale)
	/// @desc Sets the time scale of the animation player. Affects the currently playing animation.
	///
	/// @param {number}  new_scale  New time scale
	///
	/// @returns {FrameAnimationPlayer}  This player. Useful for method chaining.
    static set_time_scale = function(_new_scale) {
		timeScale = max(0, _new_scale);
		return self;
    };
	
	#endregion
	
	#region Functions - Playing Animations
	
	/// @method play(animation_name, force_play, time_scale)
	/// @desc Tells the animation player to start playing the given animation.
	///
	/// @param {string}  animation_name  The animation to play
	/// @param {bool}  [force_play]  If true, the animation will play from the beginning, even if it's already the current animation. Defaults to false.
	/// @param {number}  [time_scale]  Play the animation at a slower/faster speed than what's defined. Defaults to 1, regular speed.
	///
	/// @returns {FrameAnimationPlayer}  This player. Useful for method chaining.
    static play = function(_animName, _force = false, _timeScale = 1) {
        if (_animName == currentAnimationName && !_force)
            return;
        
        animTimer = 0;
        frameCounter = 0;
        timeScale = _timeScale;
        loops = 0;
        __isNewFrame = true;
        __prevFrame = 0;
        
        if (!struct_exists(animationMap, _animName)) {
			currentAnimation = undefined;
			currentAnimationName = "";
			return self;
        }
        
        currentAnimation = animationMap[$ _animName];
        currentAnimationName = currentAnimation.id;
        return self;
    };
    
    /// @method queue(animation_name, time_scale)
	/// @desc Queues the animation for when the current animation (& prior queued animations) is finished.
	///		  Note: If the animation doesn't loop, it cannot "finish"
	///
	/// @param {string}  animation_name  The animation to queue
	/// @param {number}  [time_scale]  Play the animation at a slower/faster speed than what's defined. Defaults to 1, regular speed.
	///
	/// @returns {FrameAnimationPlayer}  This player. Useful for method chaining.
    static queue = function(_animName, _timeScale = 1) {
		if (self.has_animation(_animName))
			array_push(__queue, _animName, _timeScale);
		return self;
    };
    
    /// @method update()
	/// @desc Runs through the current animation
    static update = function() {
		if (is_undefined(currentAnimation))
            return;
        
        var _isStalled = (timeScale == 0),
			_totalSteps = _isStalled ? 1 : ceil(timeScale),
			_timeScale = _isStalled ? 0 : timeScale;
        
        array_clear(__readFlags);
        
        repeat(_totalSteps) {
			var _step = (_timeScale > 1) ? sign(_timeScale) : _timeScale;
			
			if (__isNewFrame && !_isStalled) {
				var _flag = currentAnimation.get_flag(__prevFrame);
				if (!string_empty(_flag))
					array_push(__readFlags, _flag);
			}
			
			currentAnimation.seek(frameCounter, __isNewFrame && !_isStalled);
			animTimer += _step;
			frameCounter += _step;
			_timeScale--;
			
			if (_isStalled)
				continue;
			
			if (frameCounter >= currentAnimation.duration) {
				var _overflow = frameCounter - currentAnimation.duration;
				
				if (currentAnimation.is_looping()) {
					frameCounter = currentAnimation.find_frame_start_time(currentAnimation.resetFrame) + _overflow;
					loops++;
					
					__isNewFrame = true;
					__prevFrame = currentAnimation.resetFrame;
				} else if (!array_empty(__queue)) {
					var _nextAnim = array_shift(__queue),
						_nextTimeScale = array_shift(__queue);
					self.play(_nextAnim, true, _nextTimeScale);
					frameCounter += _overflow;
				} else {
					frameCounter = currentAnimation.duration;
				}
			} else {
				var _newFrame = currentAnimation.find_frame(frameCounter);
				__isNewFrame = (__prevFrame != _newFrame);
				__prevFrame = _newFrame;
			}
        }
    };
	
	#endregion
    
    #region Functions - Other
    
    /// @method change_time_scale(shift)
	/// @desc Changes the time scale of the animation player by a set amount. Affects the currently playing animation.
	///
	/// @param {number}  shift  The amount to change by
    static change_time_scale = function(_shift) {
		timeScale = max(0, timeScale + _shift);
    };
    
    /// @method clear_queue()
	/// @desc Clears the animation queu
    static clear_queue = function() {
		array_clear(__queue);
    }
    
    /// @method has_animation(animation_name)
	/// @desc Checks if the player has the specified animation.
	///
	/// @param {string}  animation_name  The animation to check for
	///
	/// @returns {bool}  Whether the animation was found (true) or not (false)
	static has_animation = function(_animName) {
		return struct_exists(animationMap, _animName);
	};
	
	/// @method has_flag(flag)
	/// @desc Checks if the player has read a flag from the currently playing animation
	///
	/// @param {string}  flag  The flag to check for
	///
	/// @returns {bool}  Whether the flag was read (true) or not (false)
	static has_flag = function(_flag) {
		return array_contains(__readFlags, _flag);
	};
	
	/// @method is_animation_finished(count_looping)
	/// @desc Checks if the current animation has finished.
	///
	/// @param {bool}  [count_looping]  If true, looping animations will return `true` after looping once
	///		If false (default), looping animations will always return `false`, since they do not "finish"
	///
	/// @returns {bool}  Whether the animation has finished (true) or not (false)
	static is_animation_finished = function(_countLoop = false) {
		if (is_undefined(currentAnimation))
			return true;
		if (currentAnimation.is_looping())
			return _countLoop ? (loops > 0) : false;
		return frameCounter >= currentAnimation.duration;
	};
	
	/// @method reset_frame()
	/// @desc Resets the `frameCounter` to the start of the current frame.
    static reset_frame = function() {
		var _frame = currentAnimation.find_frame(frameCounter);
		frameCounter = currentAnimation.find_frame_start_time(_frame);
        __isNewFrame = true;
		__prevFrame = _frame;
    };
	
	/// @method transfer_animation(animation)
	/// @desc Transfers an already-existing FrameAnimation into this player
	///
	/// @param {FrameAnimation}  animation  The animation to transfer
    static transfer_animation = function(_anim) {
		_anim.owner = owner;
		if (!is_undefined(_anim.callback))
			_anim.add_callback(_anim.callback); // Changes the context of the callback
		animationMap[$ _anim.id] = _anim;
    };
    
    #endregion
}

/// @func FrameAnimation(id, owner, frames, reset_frame)
/// @desc Holds data for a specific animation, that will be played by a FrameAnimationPlayer instance.
///
/// @param {string}  id  The name of the animation
/// @param {instance}  owner  Instance this FrameAnimation is bound to
/// @param {array<number>}  frames  An array representing the timing of the animation. Each element denotes how long that frame lasts.
/// @param {int}  [reset_frame]  The frame FrameAnimationPlayer should reset to after reaching the end of this animation. < 0 means the animation doesn't loop.
function FrameAnimation(_id, _owner, _frames, _resetFrame = 0) constructor {
	#region Constants (in spirit)
	
	static INDEX_NAME = 0;
	static INDEX_DATASTART = 1;
	
	#endregion
	
	#region Variables
	
    id = _id;
    owner = _owner;
    
    frames = _frames;
    totalFrames = array_length(_frames);
    resetFrame = clamp(_resetFrame, -1, totalFrames - 1);
    
    duration = array_sum(frames); /// @is {array<number>}
    timeLookup = self.__init_time_lookup(); /// @is {array<number>}
    
    properties = []; // [ [ name, data... ] ... ]
    propertyCount = 0;
    
    flags = array_create(totalFrames);
    callback = undefined; /// @is {function<int,number,bool,void>?} fn(frame, frame_progress, is_new_frame)
    
    #endregion
    
    #region Functions - Adding Properties/Callbacks
    
    /// @method add_callback(callback)
	/// @desc Adds a callback to this animation. If one already exists, the old one is replaced.
	///
	/// @param {function<int,number,bool,void>}  callback  The callback to assign, with the following arguments:
	///		-- frame: number  - The current frame
	///		-- frame_progress: number  - Progress within the current frame
	///		-- is_new_frame: bool  - Whether this should be treated as a new frame (true) or not (false)
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_callback = function(_callback) {
		callback = method(owner, _callback);
		return self;
    };
    
    /// @method add_flag(frame, flag)
	/// @desc Adds a flag on the specified frame of the animation. If one already exists, the old one is replaced.
	///
	/// @param {int}  frame  Which frame of the animation to add the flag to. Will be clamped if out of range
	/// @param {string}  flag  The flag for the given frame
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_flag = function(_frame, _flag) {
		_frame = clamp(_frame, 0, totalFrames - 1);
		flags[_frame] = _flag;
		return self;
    };
    
    /// @method add_property(property, values, lerp_type, ease_type)
	/// @desc Adds a property of the owner for the animation to update
	///
	/// @param {string}  property  The name of the variable on the owner to adjust
	/// @param {array<any>|any}  values  The value `property` becomes on each frame of this animation.
	///		If supplied as a single value, it will be applied on all frames.
	///		If the array is smaller than the frame count, the last value is repeated for all remaining frames.
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static add_property = function(_property, _values) {
		if (!is_array(_values))
			_values = [_values];
		
		var _propertyData = array_create(INDEX_DATASTART + totalFrames);
		_propertyData[INDEX_NAME] = _property;
		
		// Apply the values for the property on each animation frame
		var _valuesLength = array_length(_values),
			_thisValue = 0;
		var i = 0; repeat(totalFrames) {
			if (i < _valuesLength)
				_thisValue = _values[i];
			_propertyData[INDEX_DATASTART + i] = _thisValue;
			i++;
		}
		
		// Check if this property already exists in the animation
		var _alreadyPresentIndex = undefined;
		var i = 0; repeat(propertyCount) {
			if (properties[i][INDEX_NAME] == _propertyData[INDEX_NAME]) {
				_alreadyPresentIndex = i;
				break;
			}
			i++;
		}
		
		if (is_undefined(_alreadyPresentIndex)) {
			array_push(properties, _propertyData);
			propertyCount++;
		} else {
			properties[_alreadyPresentIndex] = _propertyData;
		}
		
		return self;
    };
    
    #endregion
    
    #region Modifying Properties
    
    /// @method remove_property(name)
	/// @desc Removes an property currently tracked by this animation
	///
	/// @param {string}  property  The name of the property
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static remove_property = function(_name) {
		var i = 0; repeat(propertyCount) {
			if (properties[i][INDEX_NAME] == _name) {
				array_delete(properties, i, 1);
				propertyCount--;
				break;
			}
			i++;
		}
		
        return self;
    };
    
    /// @method rename_property(property, new_name)
	/// @desc Renames an existing property
	///
	/// @param {string}  property  The name of the original variable on the owner
	/// @param {string}  new_name  The name of the new variable
	///
	/// @returns {FrameAnimation}  This FrameAnimation. Useful for method chaining.
    static rename_property = function(_property, _newName) {
		var i = 0; repeat(propertyCount) {
			var _prop = properties[i];
			if (_prop[INDEX_NAME] == _property) {
				_prop[INDEX_NAME] = _newName;
				break;
			}
			i++;
		}
		
        return self;
    };
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_flag(frame)
	/// @desc Gets the flag set for the specific frame of the animation, if one is set.
	///
	/// @param {int}  frame  Which frame of the animation to check
	///
	/// @returns {string}  The flag for the specified frame. Returns an empty string if the frame has no flag.
    static get_flag = function(_frame) {
		var _flag = array_at(flags, _frame) ?? "";
		return is_string(_flag) ? _flag : "";
    };
    
    /// @method get_frame_duration(frame)
	/// @desc Get the duration of a specific frame of this animation, in in-game frames
	///
	/// @param {int}  frame  Which frame of the animation to check
	///
	/// @returns {number}  The duration of the specified frame
    static get_frame_duration = function(_frame) {
		return array_at(frames, _frame) ?? 0;
    };
    
    #endregion
    
    #region Functions - Finding
    
    /// @method find_frame(time)
	/// @desc Get a frame of the animation, given the time specified
	///
	/// @param {number}  time  How far along the animation to search
	///
	/// @returns {int}  The frame within which the specified time lies
    static find_frame = function(_time) {
		if (_time <= 0)
			return 0;
		if (_time >= duration)
			return max(0, totalFrames - 1);
		
		var i = totalFrames - 1; repeat(totalFrames) {
			if (_time >= timeLookup[i])
				return i;
			i--;
		}
		
		return 0;
    };
    
    /// @method find_frame_start_time(frame)
	/// @desc Finds the time in the animation the given frame starts at
	///
	/// @param {int}  frame  The frame to get the start time for
	///
	/// @returns {number}  The time at which the given frame starts
    static find_frame_start_time = function(_frame) {
		if (_frame <= 0)
			return 0;
		if (_frame >= totalFrames)
			return duration;
		return timeLookup[_frame];
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
    
    /// @method seek(time, is_new_frame)
	/// @desc Processes the animation at the given point of time
	///
	/// @param {number}  time  The point of time within the animation
	/// @param {bool}  is_new_frame  Whether this should be treated as a newly-entered frame (true) or not (false)
    static seek = function(_time, _isNewFrame) {
		var _frame = self.find_frame(_time),
			_frameStartAt = self.find_frame_start_time(_frame),
			_frameEndAt = _frameStartAt + frames[_frame],
			_frameProgress = invlerp(_frameStartAt, _frameEndAt, _time);
		
		var _nextFrame = _frame + 1;
		if (_nextFrame >= totalFrames)
			_nextFrame = self.is_looping() ? resetFrame : _frame;
		
		for (var i = 0; i < propertyCount; i++) {
			var _prop = properties[i],
				_value = _prop[INDEX_DATASTART + _frame];
			
			owner[$ _prop[INDEX_NAME]] = _value;
		}
        
        if (!is_undefined(callback))
			callback(_frame, _frameProgress, _isNewFrame);
    };
    
    /// @method __init_time_lookup()
	/// @desc Internal function for setting up `timeLookup`
	///
	/// @returns {array<number>}
    static __init_time_lookup = function() {
		if (totalFrames <= 0)
			return [];
		
		var _timeLookup = array_create(totalFrames),
			_timeLookupCounter = 0;
		
		var i = 0; repeat(totalFrames) {
			_timeLookup[i] = _timeLookupCounter;
			_timeLookupCounter += frames[i];
			i++;
		}
		
		return _timeLookup;
    };
    
    #endregion
}
