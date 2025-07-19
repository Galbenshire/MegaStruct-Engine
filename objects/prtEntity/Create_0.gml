// Entities are your in-game actors
// Enemies, pickups, the player? All entities.
event_inherited();

image_speed = 0;

healthpoints = healthpointsStart;
lifeState = LifeState.DEAD_OFFSCREEN; /// @is {int}
iFrames = 0;

factionLayer = array_reduce(factionLayer, function(_prev, _curr, i) /*=>*/ {return _prev | _curr}, 0); /// @is {int}
factionMask = array_reduce(factionMask, function(_prev, _curr, i) /*=>*/ {return _prev | _curr}, 0); /// @is {int}
factionTargetWhitelist = array_reduce(factionTargetWhitelist, function(_prev, _curr, i) /*=>*/ {return _prev | _curr}, 0); /// @is {int}
factionSolidWhitelist = array_reduce(factionSolidWhitelist, function(_prev, _curr, i) /*=>*/ {return _prev | _curr}, 0); /// @is {int}

damageTable = new DamageTable();
hitTimer = 9999;
lastHitBy = noone; /// @is {prtEntity}
hitIgnoreList = []; /// @is {array<prtEntity>}

hitboxes = []; /// @is {array<prtHitbox>}
hitboxCount = 0;

reticle = (targetingPreset != ReticlePresetType.NO_TARGET) ? (new Reticle(targetingPreset)) : undefined; /// @is {Reticle}

xspeed = new Fractional();
yspeed = new Fractional();
externalXForce = new Fractional();
externalYForce = new Fractional();

xcoll = 0;
xcollInstance = noone; /// @is {instance}
ycoll = 0;
ycollInstance = noone; /// @is {instance}

ground = gravEnabled; /// @is {bool}
groundInstance = noone; /// @is {instance}

ladderInstance = noone; /// @is {instance}

grav = abs(grav);
gravDir = (gravDir == 0) ? DEFAULT_GRAVITY_DIRECTION : sign(gravDir);
maxFallSpeed = abs(maxFallSpeed);

respawnRange = (respawnRange < 0) ? infinity : respawnRange;
despawnRange = (despawnRange < 0) ? infinity : despawnRange;

inWater = interactWithWater && place_meeting(x, y, objWater); /// @is {bool}
bubbleTimer = 0; /// @is {int}

frozenTimer = 0;
frozenGraphicType = 0;
frozenPhysicsEnabled = false;

__isKilled = false; // Used for respawn checks

// Callbacks
// - Spawning
onSpawn = method(id, cbkOnSpawn_prtEntity); /// @is {function<void>}
onDespawn = method(id, cbkOnDespawn_prtEntity); /// @is {function<void>}
// - Attacking
onSetDamage = method(id, cbkOnSetDamage_prtEntity); /// @is {function<DamageSource, void>}
onGuard = method(id, cbkOnGuard_prtEntity); /// @is {function<DamageSource, void>}
onReflected = method(id, cbkOnReflected_prtEntity); /// @is {function<DamageSource, void>}
onAttackBegin = method(id, cbkOnAttackBegin_prtEntity); /// @is {function<DamageSource, void>}
onAttackEnd = method(id, cbkOnAttackEnd_prtEntity); /// @is {function<DamageSource, void>}
onHurt = method(id, cbkOnHurt_prtEntity); /// @is {function<DamageSource, void>}
onDeath = method(id, cbkOnDeath_prtEntity); /// @is {function<DamageSource, void>}
// - Drawing
onDraw = method(id, cbkOnDraw_prtEntity); /// @is {function<bool, void>}
// - Item Drop
onItemDrop = method(id, cbkOnItemDrop); /// @is {function<instance, void>}

// Setup Reticle based on preset
switch (targetingPreset) {
	case "Generic":
		reticle.set_on_update(fnsReticle_onUpdate_Generic);
		reticle.set_on_retarget(fnsReticle_onRetarget_PickNearestEstimate);
		break;
	case "Nearest":
		reticle.set_on_update(fnsReticle_onUpdate_AlwaysRetarget);
		reticle.set_on_retarget(fnsReticle_onRetarget_PickNearest);
		break;
	case "Switch Regularly":
		reticle.set_on_update(fnsReticle_onUpdate_SwitchRegularly);
		reticle.set_on_retarget(fnsReticle_onRetarget_PickAtRandom);
		break;
	case "Pick Once":
		reticle.set_on_retarget(fnsReticle_onRetarget_PickAtRandom);
		break;
}