/// @description Entity Tick
image_index += 0.5;

if (--dealDamageDelay == 0)
    hitmask = bitmask_set_bit(hitmask, HitMask.DEAL_DAMAGE);
