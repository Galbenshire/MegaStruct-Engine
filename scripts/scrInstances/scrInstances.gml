/// @func calibrate_direction_object(target, scope)
/// @desc This function will set the specified instance's image_xscale to face towards another instance
///       The size of image_xscale will be preserved.
///
/// @param {instance}  target  The instance to face towards
/// @param {instance}  [scope]  The instance to perform this on. Defaults to the calling instance.
function calibrate_direction_object(_target, _scope = self) {
    if (!instance_exists(_target))
        return;
    calibrate_direction_point(_target.x, _scope);
}

/// @func calibrate_direction_point(x, scope)
/// @desc This function will set the specified instance's image_xscale to face towards the given x position
///       The size of image_xscale will be preserved.
///
/// @param {number}  x  The x-position to face towards
/// @param {instance}  [scope]  The instance to perform this on. Defaults to the calling instance.
function calibrate_direction_point(_x, _scope = self) {
    var _dir = sign(_x - _scope.x);
    if (_dir != 0)
        image_xscale = _dir * abs(image_xscale);
}

/// @func instance_all(obj, predicate)
/// @desc This function will check to see if all instances of the specified object fulfills the predicate condition
///
/// @param {object}  obj  The object to check against
/// @param {function<instance,int,bool>}  predicate  The Predicate Method to run on each instance
///
/// @returns {bool}  Whether the predicate was fulfilled on all instances (true), or not (false)
function instance_all(_obj, _predicate) {
    var _count = instance_number(_obj);
    for (var i = 0; i < _count; i++) {
        if (!_predicate(instance_find(_obj, i), i))
            return false;
    }
    return true;
}

/// @func instance_any(obj, predicate)
/// @desc This function will check to see if any instance of the specified object fulfills the predicate condition
///
/// @param {object}  obj  The object to check against
/// @param {function<instance,int,bool>}  predicate  The Predicate Method to run on each instance
///
/// @returns {bool}  Whether the predicate was fulfilled on any instance (true), or not (false)
function instance_any(_obj, _predicate) {
    var _count = instance_number(_obj);
    for (var i = 0; i < _count; i++) {
        if (_predicate(instance_find(_obj, i), i))
            return true;
    }
    return false;
}

/// @func instance_create(x, y, depth_or_layer, obj, var_struct)
/// @desc General purpose version of the instance_create_* functions
///
/// @param {number}  x  The x position the instance of the given object will be created at
/// @param {number}  y  The y position the instance of the given object will be created at
/// @param {number|layer|string}  depth_or_layer  The depth/layer to assign the created instance to
/// @param {object}  obj  The object index of the object to create an instance of
/// @param {struct}  [var_struct]  A struct with variables to assign to the new instance. Optional.
///
/// @returns {instance}  An instance of the object specified
function instance_create(_x, _y, _depthOrLayer, _obj, _vars = {}) {
    var _depth = (typeof(_depthOrLayer) == "number")
		? _depthOrLayer
		: layer_get_depth(_depthOrLayer);
	return instance_create_depth(_x, _y, _depth, _obj, _vars);
}

/// @func is_object_type(object_index, scope)
/// @desc Returns whether a specified instance is of a certain object,
///		  or is a descendent of the specified object.
///
/// @param {object}  object_index  Object to check against the calling instance. 
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is related to the object_index (true), or not (false)
function is_object_type(_obj, _scope = self) {
	if (!instance_exists(_obj))
		return false;
    return _scope.object_index == _obj || object_is_ancestor(_scope.object_index, _obj);
}