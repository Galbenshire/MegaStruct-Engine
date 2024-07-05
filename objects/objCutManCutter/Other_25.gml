/// @description Entity Post Tick
if (!returnToParent || !instance_exists(owner))
    exit;

if (point_distance(x, y, owner.x, owner.y) <= 4)
    instance_destroy();
