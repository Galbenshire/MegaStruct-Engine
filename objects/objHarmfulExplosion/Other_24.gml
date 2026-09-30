/// @description Entity Tick
if (image_index + animSpeed < image_number)
    image_index += animSpeed;
else
    instance_destroy();

if (image_index >= damageDisablePoint)
    hitmaskMaster = bitmask_unset_bit(hitmaskMaster, HitMask.DEAL_DAMAGE);
