/// @description Entity Tick
image_index += 0.25;

if (returnToParent) {
    if (instance_exists(owner)) {
        var _direction = point_direction(x, y, owner.x, owner.y);
        set_velocity_vector(3, _direction);
    }
} else {
    returnToParent = !inside_view_point(x, y, -8);
}