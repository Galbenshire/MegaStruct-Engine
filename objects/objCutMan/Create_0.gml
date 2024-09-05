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
    stateMachine.change("Hurt");
};
onDeath = function(_damageSource) {
    cbkOnDeath_prtBoss(_damageSource);
    with (objCutManCutter)
        instance_destroy();
};

// == Damage Table ==
damageTable.add_source(objBusterShot, 2);
damageTable.add_source(objBusterShotHalfCharge, 2);
damageTable.add_source(objBusterShotCharged, 4);
damageTable.add_source(objProtoShot, 2);
damageTable.add_source(objProtoShotHalfCharge, 2);
damageTable.add_source(objProtoShotCharged, 4);
damageTable.add_source(objBassShot, 2);
damageTable.add_source(objIceSlasher, 0);
damageTable.add_source(objMetalBlade, 1);
damageTable.add_source(objSearchSnake, 1);