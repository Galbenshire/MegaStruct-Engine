image_index += 0.2;

if (__dealDamageDelay-- == 0)
    hitmask = bitmask_set_bit(hitmask, HitMask.DEAL_DAMAGE);