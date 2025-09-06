event_inherited();

iFrameDuration += 30; // To account for Cut Man's knockback

moveSpeed = 0;

cutterExists = false;
cutterInstance = noone;

canThrowInAir = false;
airThrowTimer = 0;

shootFlag = false;

// == Callbacks ==
onHurt = function(_damageSource) {
    cbkOnHurt_prtBoss(_damageSource);
    stateMachine.change_state("Hurt");
};
onDeath = function(_damageSource) {
    cbkOnDeath_prtBoss(_damageSource);
    with (objCutManCutter)
        instance_destroy();
};

// == Damage Table ==
damageTable.add_entry(objBusterShot, 2);
damageTable.add_entry(objBusterShotHalfCharge, 2);
damageTable.add_entry(objBusterShotCharged, 4);
damageTable.add_entry(objProtoShot, 2);
damageTable.add_entry(objProtoShotHalfCharge, 2);
damageTable.add_entry(objProtoShotCharged, 4);
damageTable.add_entry(objBassShot, 2);
damageTable.add_entry(objIceSlasher, 0);
damageTable.add_entry(objMetalBlade, 1);
damageTable.add_entry(objSearchSnake, 1);
damageTable.add_entry(objSkullBarrier, 1);