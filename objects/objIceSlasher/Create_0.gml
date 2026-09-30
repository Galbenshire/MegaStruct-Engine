event_inherited();

// Callbacks
onAttackEnd = function(_damageSource) {
    with (_damageSource) {
        if (hasKilled || !subject.canBeFrozen)
            return;
        entity_freeze(360, $FF7800, subject);
    }
};