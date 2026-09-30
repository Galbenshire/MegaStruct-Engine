var _prevBurrowBitfield = burrowBitField;
event_user(2);

if (burrowBitField == _prevBurrowBitfield)
    exit;

if (__spawnedBurrowed && burrowBitField == bitMask_HeadExposed) {
    y = yprevious;
    burrowBitField = _prevBurrowBitfield;
}

hitmask = bitmask_toggle_bit(hitmask, HitMask.DEAL_DAMAGE | HitMask.TAKE_DAMAGE, burrowBitField != bitMask_FullyBuried);
if (burrowBitField == bitMask_HeadExposed) {
    hitmask = bitmask_unset_bit(hitmask, HitMask.DEAL_DAMAGE);
    __dealDamageDelay = 20;
}

event_user(0); // Pick new move speed
event_user(1); // Emit sparks (if applicable)

__spawnedBurrowed = false;
