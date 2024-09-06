/// @func Reticle()
/// @desc A struct that allows for an entity to target other entities
function Reticle() constructor {
    #region Variables
    
    owner = other.id; /// @is {prtEntity} The instance this belongs to
    
    // Last position of the target
    x = owner.x;
    y = owner.y;
    
    target = noone; /// @is {prtEntity} Reference to the entity we're currently targetting
    targetExists = false; // Tracks if the current target is valid
    timer = 0; // How long we've been tracking the current target
    
    #endregion
    
    #region Callbacks
    
    onUpdate = method(self, __blankCallback); /// @is {function<void>}
    onRetarget = method(self, __blankCallback); /// @is {function<void>}
    
    #endregion
    
    #region Function - Setters
    
    /// -- set_on_update(func)
	/// Sets the function to perform on the onUpdate callback
	///
	/// @param {function<void>}  func  The function that will become the callback
    static set_on_update = function(_func) {
        onUpdate = method(self, _func);
    };
    
    /// -- set_on_retarget(func)
	/// Sets the function to perform on the onRetarget callback
	///
	/// @param {function<void>}  func  The function that will become the callback
    static set_on_retarget = function(_func) {
        onRetarget = method(self, _func);
    };
    
    #endregion
    
    #region Functions - Direction
    
    /// -- direction_to_target()
	/// Calculates the direction towards the target
	///
	/// @returns {number}  The direction towards the target
    static direction_to_target = function() {
    	return point_direction(owner.x, owner.y, x, y);
    };
    
    #endregion
    
    #region Functions - Distance
    
    /// -- distance_to_target()
	/// Calculates the distance to the last know target position
	///
	/// @returns {number}  The distance to the target position
    static distance_to_target = function() {
        return point_distance(owner.x, owner.y, x, y);  
    };
    
    /// -- distance_to_target_x()
	/// Calculates the distance to the last know target x-coordinate
	///
	/// @returns {number}  The distance to the target x-coordinate
    static distance_to_target_x = function() {
        return abs(owner.x - x);  
    };
    
    /// -- distance_to_target_y()
	/// Calculates the distance to the last know target y-coordinate
	///
	/// @returns {number}  The distance to the target y-coordinate
    static distance_to_target_y = function() {
        return abs(owner.y - y);  
    };
    
    #endregion
    
    #region Functions - Other
    
    /// -- clear_target()
	/// Clears the reference to the current target
    static clear_target = function() {
        target = noone;
        targetExists = false;
    };
    
    /// -- is_target_valid(target)
	/// Checks if the given target is a valid one
	///
	/// @param {prtEntity}  [target]  The entity we wish to check. Defaults to what the Reticle is currently tracking.
	///
	/// @returns {bool}  If the target is valid (true) or not (false)
    static is_target_valid = function(_target = target) {
        if (!instance_exists(_target))
            return false;
        return !entity_is_dead(_target) && _target.canTakeDamage && (entity_faction_targets(owner) & _target.factionLayer > 0);
    };
    
    /// -- switch_target(new_target)
	/// Assigns a new target, resetting the timer & updating the target coordinates
	///
	/// @param {prtEntity}  new_target  The new target
    static switch_target = function(_newTarget) {
        target = _newTarget;
        targetExists = true;
        timer = 0;
        x = target.x;
        y = target.y;
    };
    
    /// -- update()
	/// This function will update our known position of the target
	/// If the target is lost, a new target will be found
    static update = function() {
        timer++;
        
        if (!is_target_valid()) {
            clear_target();
        } else {
            x = target.x;
            y = target.y;
            onUpdate();
        }
        
        if (!targetExists)
            onRetarget();
    };
    
    #endregion
    
    #region Private Stuff
    
    /// -- __blankCallback()
    /// Only here to supply the default callbacks. Not intended for use otherwise.
    static __blankCallback = function() {};
    
    #endregion
}

#region Callback Presets - onUpdate

/// @self {Reticle}
/// @func fnsReticle_onUpdate_AlwaysRetarget()
/// @desc Clears the Reticle's target reference, ensuring it always retargets every game frame
function fnsReticle_onUpdate_AlwaysRetarget() {
    clear_target();
}

/// @self {Reticle}
/// @func fnsReticle_onUpdate_Generic()
/// @desc Generic "smart" AI.
///       If the current target is far enough away, and hasn't attacked recently,
///       there is a small chance to retarget.
function fnsReticle_onUpdate_Generic() {
    if (owner.hitTimer <= 100 || irandom(500))
        return;
    if (distance_to_target() > 80)
        clear_target();
}

/// @self {Reticle}
/// @func fnsReticle_onUpdate_SwitchRegularly()
/// @desc Clears the Reticle's target reference at a set interval
function fnsReticle_onUpdate_SwitchRegularly() {
    if (timer >= 140)
        clear_target();
}

#endregion

#region Callback Presets - onRetarget

/// @self {Reticle}
/// @func fnsReticle_onRetarget_PickAtRandom()
/// @desc Picks an active & eligeable entity at random
function fnsReticle_onRetarget_PickAtRandom() {
    var _entities = [],
        _owner = owner;
    with (prtEntity) {
        if (entity_can_target_entity(self, _owner))
            array_push(_entities, self.id);
    }
    
    if (array_length(_entities) <= 0)
        return;
    
    switch_target(choose_from_array(_entities));
}

/// @self {Reticle}
/// @func fnsReticle_onRetarget_PickNearest()
/// @desc Picks the closest valid entity to the Reticle's owner
function fnsReticle_onRetarget_PickNearest() {
    var _entities = collision_circle_array(owner.x, owner.y, 512, prtEntity, false, true, true);
    _entities = array_filter(_entities, function(el, i) /*=>*/ {return entity_can_target_entity(el, owner)});
    
    if (array_length(_entities) <= 0)
        return;
    
    switch_target(_entities[0]);
}

/// @self {Reticle}
/// @func fnsReticle_onRetarget_PickNearestEstimate()
/// @desc Finds the closest valid entities to the Reticle's owner.
///       Those that are close to each other will then be picked from random.
///       This will make entities target those not neccessarily the closest, but close enough.
function fnsReticle_onRetarget_PickNearestEstimate() {
    var _entities = collision_circle_array(owner.x, owner.y, 512, prtEntity, false, true, true);
    _entities = array_filter(_entities, function(el, i) /*=>*/ {return entity_can_target_entity(el, owner)});
    
    var _entityCount = array_length(_entities);
    if (_entityCount <= 0)
        return;
    
    var _minDistance = point_distance(owner.x, owner.y, _entities[0].x, _entities[0].y);
    for (var i = _entityCount - 1; i >= 1; i--) {
        var _distance = point_distance(owner.x, owner.y, _entities[i].x, _entities[i].y);
        if (_distance - _minDistance > 10) {
            array_delete(_entities, i, 1);
            _entityCount--;
        }
    }
    
    switch_target(choose_from_array(_entities));
}

#endregion
