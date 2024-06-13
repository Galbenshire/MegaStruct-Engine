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

/// @func is_object_type(object_index, scope)
/// @desc Returns whether a specified instance is of a certain object,
///		  or is a descendent of the specified object.
///
/// @param {object}  object_index  Object to check against the calling instance. 
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is related to the object_index (true), or not (false)
function is_object_type(_obj, _scope = self) {
    if (!instance_exists(_scope))
        return false;
    return _scope.object_index == _obj || object_is_ancestor(_scope.object_index, _obj);
}