event_inherited();

distanceToMiddle = 0;

shootFlag = false;
jumpFlag = false;

conveyorTimer = 0;
conveyorSpriteList = [];
conveyorAreaList = [];

playerShotListener = undefined;

// == Damage Table ==
damageTable.add_source(objBusterShot, 1);
damageTable.add_source(objBusterShotHalfCharge, 1);
damageTable.add_source(objBusterShotCharged, 3);
damageTable.add_source(objProtoShot, 1);
damageTable.add_source(objProtoShotHalfCharge, 1);
damageTable.add_source(objProtoShotCharged, 3);
damageTable.add_source(objBassShot, 1);
damageTable.add_source(objIceSlasher, 0);
damageTable.add_source(objMetalBlade, 99);
damageTable.add_source(objSearchSnake, 0);