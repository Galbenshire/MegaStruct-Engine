event_inherited();

killPierceWhitelist = [
    objBusterShotCharged,
    objProtoShotCharged
];

// Callbacks
onHandleBlock = function(_damageSource) {
	_damageSource.blockType = BlockType.NONE;
    if (_damageSource.damage == 0)
        _damageSource.damageEnabled = false;
};
onHurt = function(_damageSource) {
    // Most kill-piercing weapons will lose their piercing power on killing this egg
    // (charged Buster shots are the main exception. let's give the player some fun here)
    cbkOnHurt_base(_damageSource);
    with (_damageSource) {
        if (pierces == PierceType.ON_KILLS_ONLY && !array_contains(subject.killPierceWhitelist, attacker.object_index))
            pierces = PierceType.NEVER;
    }
};

// Item Drop code
itemDrop.set_on_custom_item_drop(function(_item) {
	_item.respawnType = RespawnType.DISABLED;
	_item.depth -= 2;
});

// Immunities
damageTable.add_entry(objIceSlasher, 0);
damageTable.add_entry(objSearchSnake, 0);
damageTable.add_entry(objSkullBarrier, 0);