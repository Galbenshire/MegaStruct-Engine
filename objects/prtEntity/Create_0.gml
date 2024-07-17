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

hitTimer = 9999;
lastHitBy = noone; /// @is {prtEntity}
hitIgnoreList = []; /// @is {array<prtEntity>}

reticle = (targetingPreset != "No Target") ? (new Reticle()) : undefined; /// @is {Reticle}

xspeed = new Fractional(); /// @is {Fractional}
yspeed = new Fractional(); /// @is {Fractional}

xcoll = 0;
xcollInstance = noone; /// @is {instance}
ycoll = 0;
ycollInstance = noone; /// @is {instance}

ground = true;
groundInstance = noone; /// @is {instance}

ladderInstance = noone; /// @is {instance}

grav = abs(grav);
gravDir = (gravDir == 0) ? DEFAULT_GRAVITY_DIRECTION : sign(gravDir);
maxFallSpeed = abs(maxFallSpeed);

respawnRange = (respawnRange < 0) ? infinity : respawnRange;
despawnRange = (despawnRange < 0) ? infinity : despawnRange;

inWater = interactWithWater && place_meeting(x, y, objWater); /// @is {bool}
bubbleTimer = 0; /// @is {int}

// Callbacks
// - Spawning
onSpawn = method(id, onSpawn); /// @is {function<void>}
onDespawn = method(id, onDespawn); /// @is {function<void>}
// - Attacking
onSetDamage = method(id, onSetDamage); /// @is {function<DamageSource, void>}
onGuard = method(id, onGuard); /// @is {function<DamageSource, void>}
onReflected = method(id, onReflected); /// @is {function<DamageSource, void>}
onAttackBegin = method(id, onAttackBegin); /// @is {function<DamageSource, void>}
onAttackEnd = method(id, onAttackEnd); /// @is {function<DamageSource, void>}
onHurt = method(id, onHurt); /// @is {function<DamageSource, void>}
onDeath = method(id, onDeath); /// @is {function<DamageSource, void>}
// - Drawing
onDraw = method(id, onDraw); /// @is {function<bool, void>}

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
	case "SwitchRegularly":
		reticle.set_on_update(fnsReticle_onUpdate_SwitchRegularly);
		reticle.set_on_retarget(fnsReticle_onRetarget_PickAtRandom);
		break;
	case "PickOnce":
		reticle.set_on_retarget(fnsReticle_onRetarget_PickAtRandom);
		break;
}