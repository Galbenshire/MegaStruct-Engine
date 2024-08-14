if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

array_push(owner.hitboxes, id);
owner.hitboxCount++;

event_user(0);