if (!instance_exists(owner)) {
    entity_kill_self();
} else {
    image_xscale = owner.image_xscale;
    image_yscale = owner.image_yscale;
    x = sprite_x_center(owner) + 9 * image_xscale;
    y = sprite_y_center(owner);
}

event_inherited();
