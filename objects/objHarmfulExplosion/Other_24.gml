/// @description Entity Tick
if (image_index + animSpeed < image_number)
    image_index += animSpeed;
else
    entity_kill_self();

if (image_index >= damageDisablePoint)
    canDealDamage = false;
