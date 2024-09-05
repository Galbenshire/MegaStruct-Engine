event_inherited();

// Callbacks
onAttackEnd = function(_damageSource) {
    with (_damageSource) {
        if (hasKilled || !subject.canBeFrozen)
            return;
        subject.frozenTimer = 360;
    }
};