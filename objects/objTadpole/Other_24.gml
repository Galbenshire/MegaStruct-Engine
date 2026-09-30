/// @description Tick
image_index += animSpeed;

if (reticle.targetExists) {
    var _spd = min(followSpeed, reticle.distance_to_target()),
        _dir = reticle.direction_to_target();
    set_velocity_vector(_spd, _dir);
} else {
    xspeed = followSpeed * image_xscale;
    yspeed = 0;
}
