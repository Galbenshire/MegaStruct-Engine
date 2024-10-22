/// @description Common Init
/// @init
// This User Event initializes variables/callbacks common between both Gemini Man & his clone

counterFlag = false;
shootFlag = false;

isAlone = false;
isStalled = false;

playerShotListener = undefined;

runDir = 0;
runToX = x;
jumpToX = x;

clone = noone;
laserCounter = 120;
stallCache = {};

// == Callbacks ==
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    
    var _middleX = game_view().center_x();
    runToX = x;
	jumpToX = _middleX - (x - _middleX);
    playerShotListener = signal_bus().connect_to_signal("playerShot", self, function(_data) {
        if (_data.player == reticle.target)
            counterFlag = true;
    });
};
onDespawn = function() {
    cbkOnDespawn_prtEntity();
    event_perform(ev_cleanup, 0);
};
onHurt = function(_damageSource) {
	cbkOnHurt_prtBoss(_damageSource);
	
	with (clone)
		iFrames = other.iFrames;
	
	if (!isAlone && (healthpoints < (healthpointsStart / 2))) {
		with (clone)
			entity_kill_self();
		
		isStalled = false;
		isAlone = true;
	}
};

// == Damage Table ==
damageTable.add_source(objBusterShot, 1);
damageTable.add_source(objBusterShotHalfCharge, 1);
damageTable.add_source(objBusterShotCharged, 3);
damageTable.add_source(objProtoShot, 1);
damageTable.add_source(objProtoShotHalfCharge, 1);
damageTable.add_source(objProtoShotCharged, 3);
damageTable.add_source(objBassShot, 1);
damageTable.add_source(objIceSlasher, 1);
damageTable.add_source(objMetalBlade, 1);
damageTable.add_source(objSearchSnake, 5);
damageTable.add_source(objSkullBarrier, 1);