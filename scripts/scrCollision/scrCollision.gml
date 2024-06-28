/// @func collision_circle_array(x, y, radius, obj, prec, notme, ordered)
/// @desc Checks a circular area for a collision with all instances of a specified object.
///       The results are then placed into an array.
///
/// @param {number}  x  The x coordinate of the center of the circle to check.
/// @param {number}  y  The y coordinate of the center of the circle to check.
/// @param {number}  radius  The radius (distance in pixels from its center to its edge).
/// @param {object}  obj  The object we're checking for.
/// @param {bool}  prec  Whether the check is based on pixel-perfect collisions (true = slow) or its bounding box in general (false = fast).
/// @param {bool}  notme  Whether the calling instance, if relevant, should be excluded (true) or not (false).
/// @param {bool}  ordered  Whether the array should be ordered by distance (true) or not (false).
///
/// @return {array<instance>}  An array of instances colliding with the circular area
function collision_circle_array(_x, _y, _radius, _obj, _prec, _notme, _ordered) {
    var _list = ds_list_create();
    collision_circle_list(_x, _y, _radius, _obj, _prec, _notme, _list, _ordered);
    return ds_list_to_array(_list);
}

/// @func collision_rectangle_array(x1, y1, x2, y2, obj, prec, notme, ordered)
/// @desc Checks a rectangular area for a collision with all instances of a specified object.
///       The results are then placed into an array.
///
/// @param {number}  x1  The x coordinate of the left side of the rectangle to check.
/// @param {number}  y1  The y coordinate of the top side of the rectangle to check.
/// @param {number}  x2  The x coordinate of the right side of the rectangle to check.
/// @param {number}  y2  The y coordinate of the bottom side of the rectangle to check.
/// @param {object}  obj  The object we're checking for.
/// @param {bool}  prec  Whether the check is based on pixel-perfect collisions (true = slow) or its bounding box in general (false = fast).
/// @param {bool}  notme  Whether the calling instance, if relevant, should be excluded (true) or not (false).
/// @param {bool}  ordered  Whether the array should be ordered by distance (true) or not (false).
///
/// @return {array<instance>}  An array of instances colliding with the rectangular area
function collision_rectangle_array(_x1, _y1, _x2, _y2, _obj, _prec, _notme, _ordered) {
    var _list = ds_list_create();
    collision_rectangle_list(_x1, _y1, _x2, _y2, _obj, _prec, _notme, _list, _ordered);
    return ds_list_to_array(_list);
}

/// @func instance_place_array(x, y, obj, ordered)
/// @desc Checks a position for a collision with all instances of an object,
///       using the collision mask of the instance that runs the code.
///       The results are then placed into an array.
///
/// @param {number}  x  The x position to check for instances.
/// @param {number}  y  The y position to check for instances.
/// @param {object}  obj  The object we're checking for.
/// @param {bool}  ordered  Whether the array should be ordered by distance (true) or not (false).
///
/// @return {array<instance>}  An array of instances the calling instance is colliding with
function instance_place_array(_x, _y, _obj, _ordered) {
    var _list = ds_list_create();
    instance_place_list(_x, _y, _obj, _list, _ordered);
    return ds_list_to_array(_list);
}

/// @func instance_position_array(x, y, obj, ordered)
/// @desc Checks a position for a collision with all instances of an object.
///       A single point will be used here.
///       The results are then placed into an array.
///
/// @param {number}  x  The x position to check for instances.
/// @param {number}  y  The y position to check for instances.
/// @param {object}  obj  The object we're checking for.
/// @param {bool}  ordered  Whether the array should be ordered by distance (true) or not (false).
///
/// @return {array<instance>}  An array of instances the calling instance is colliding with
function instance_position_array(_x, _y, _obj, _ordered) {
    var _list = ds_list_create();
    instance_position_list(_x, _y, _obj, _list, _ordered);
    return ds_list_to_array(_list);
}
