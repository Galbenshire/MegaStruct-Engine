if (!instance_exists(owner)) {
    entity_kill_self();
} else {
    x = sprite_x_center(owner);
    y = sprite_y_center(owner);
}

event_inherited();