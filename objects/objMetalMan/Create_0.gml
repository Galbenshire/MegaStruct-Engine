event_inherited();

distanceToMiddle = 0;

shootFlag = false;
jumpFlag = false;

conveyorTimer = 0;
conveyorSpriteList = [];
conveyorAreaList = [];

playerShotListener = undefined;

// == Callbacks ==
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    
    distanceToMiddle = abs(x - game_view().center_x());
    playerShotListener = signal_bus().connect_to_signal("playerShot", self, function(_data) {
        if (_data.player == reticle.target)
            jumpFlag = true;
    });
};
onDespawn = function() {
    cbkOnDespawn_prtEntity();
    event_perform(ev_cleanup, 0);
};
onDeath = function(_damageSource) {
    cbkOnDeath_prtBoss(_damageSource);
    
    with (objGenericEnemyBullet) {
        if (owner == other.id)
            instance_destroy();
    }
};

// == Damage Table ==
damageTable.add_entry(objBusterShot, 1);
damageTable.add_entry(objBusterShotHalfCharge, 1);
damageTable.add_entry(objBusterShotCharged, 3);
damageTable.add_entry(objProtoShot, 1);
damageTable.add_entry(objProtoShotHalfCharge, 1);
damageTable.add_entry(objProtoShotCharged, 3);
damageTable.add_entry(objBassShot, 1);
damageTable.add_entry(objIceSlasher, 0);
damageTable.add_entry(objMetalBlade, 99);
damageTable.add_entry(objSearchSnake, 0);
damageTable.add_entry(objSkullBarrier, 0);