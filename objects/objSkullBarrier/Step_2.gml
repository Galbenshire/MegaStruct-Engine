if (!instance_exists(owner)) {
    entity_kill_self();
} else {
    x = sprite_x_center(owner);
    y = sprite_y_center(owner);
    subPixelX = owner.subPixelX;
    subPixelY = owner.subPixelY;
}

event_inherited();