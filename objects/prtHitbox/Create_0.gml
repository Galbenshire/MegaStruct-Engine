if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

image_speed = 0;

array_push(owner.hitboxes, id);
owner.hitboxCount++;

hitmask = bitmask_merge_bits(hitmask); /// @is {int}

event_user(0);