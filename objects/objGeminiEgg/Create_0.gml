event_inherited();

killPierceWhitelist = [
    objBusterShotCharged,
    objProtoShotCharged
];

// Callbacks
onGuard = function(_damageSource) {
    if (_damageSource.damage == 0)
        _damageSource.guard = GuardType.IGNORE;
};
onHurt = function(_damageSource) {
    // Most kill-piercing weapons will lose their piercing power on killing this egg
    // (charged Buster shots are the main exception. let's give the player some fun here)
    cbkOnHurt_prtEntity(_damageSource);
    with (_damageSource) {
        if (attacker.pierces == PierceType.ON_KILLS_ONLY && !array_contains(subject.killPierceWhitelist, attacker.object_index))
            attacker.pierces = PierceType.NEVER;
    }
};
onItemDrop = function(_item) {
    _item.depth -= 2; 
};

// Immunities
damageTable.add_source(objIceSlasher, 0);
damageTable.add_source(objSearchSnake, 0);
damageTable.add_source(objSkullBarrier, 0);