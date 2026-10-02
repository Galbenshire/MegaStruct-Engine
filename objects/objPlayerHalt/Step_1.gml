if (!isDone)
    exit;

if (instance_exists(player)) {
    if (forceStopSliding && player.isSliding)
        exit;
}

instance_destroy();