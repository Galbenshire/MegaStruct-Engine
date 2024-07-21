var _prevBurrowBitfield = burrowBitField;
event_user(2);

if (burrowBitField == _prevBurrowBitfield)
    exit;

if (__spawnedBurrowed && burrowBitField == bitMask_HeadExposed) {
    y = yprevious;
    burrowBitField = _prevBurrowBitfield;
}

canTakeDamage = (burrowBitField != bitMask_FullyBuried);
canDealDamage = canTakeDamage;
if (burrowBitField == bitMask_HeadExposed) {
    canDealDamage = false;
    __dealDamageDelay = 20;
}

event_user(0); // Pick new move speed
event_user(1); // Emit sparks (if applicable)

__spawnedBurrowed = false;
