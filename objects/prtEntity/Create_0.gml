// Entities are your in-game actors
// Enemies, pickups, the player? All entities.
event_inherited();

image_speed = 0;

#region Variables

owner = noone; /// @is {prtEntity}
createdBy = noone; /// @is {prtEntity}

healthpoints = healthpointsStart;
lifeState = LifeState.DEAD_OFFSCREEN; /// @is {int}
iFrames = 0;
iFrameFlashStyle = IFrameFlashType.WHITEFLASH;

hitmask = bitmask_merge_bits(hitmask); /// @is {int}
hitmaskMaster = HitMask.FULL; /// @is {int} Affects all hitboxes tied to this entity

factionLayer = bitmask_merge_bits(factionLayer); /// @is {int}
factionMask = bitmask_merge_bits(factionMask); /// @is {int}
factionTargetMask = array_empty(factionTargetMask) ? factionMask : bitmask_merge_bits(factionTargetMask); /// @is {int}
factionSolidMask = array_empty(factionSolidMask) ? 0xFFFFFFFF : bitmask_merge_bits(factionSolidMask); /// @is {int}

damageTable = new DamageTable();
hitTimer = 9999;
lastHitBy = noone; /// @is {prtEntity}
hitIgnoreList = []; /// @is {array<prtEntity>}

hitboxes = []; /// @is {array<prtHitbox>}
hitboxCount = 0;

reticle = (targetingPreset != ReticlePresetType.NO_TARGET) ? (new Reticle(targetingPreset)) : undefined; /// @is {Reticle}
itemDrop = new ItemDrop(itemDropType, dropItemOnce, customItemDrop);

xspeed = 0;
yspeed = 0;
externalXForce = 0;
externalYForce = 0;

collisionOverrides = {};

xcoll = 0;
xcollInstance = noone; /// @is {instance}
ycoll = 0;
ycollInstance = noone; /// @is {instance}

ground = gravEnabled; /// @is {bool}
groundInstance = noone; /// @is {instance}
ladderInstance = noone; /// @is {instance}
wallInstance = noone; /// @is {instance}
maxSlopeSteepness = DEFAULT_MAX_SLOPE_STEEPNESS;

grav = abs(grav);
gravDir = (gravDir == 0) ? DEFAULT_GRAVITY_DIRECTION : sign(gravDir);
maxFallSpeed = abs(maxFallSpeed);

respawnRange = (respawnRange < 0) ? infinity : respawnRange;
despawnRange = (despawnRange < 0) ? infinity : despawnRange;

inWater = interactWithWater && place_meeting(x, y, objWater); /// @is {bool}
bubbleTimer = 0; /// @is {int}
bubbleXOffset = x - bbox_x_center();
bubbleYOffset = y - bbox_y_center();

frozenTimer = 0;
frozenGraphicType = 0;
frozenPhysicsEnabled = false;

__isKilled = false; // Used for respawn checks
__currentTick = 0;

#endregion

#region Callbacks

// - Spawning
onSpawn = method(id, cbkOnSpawn_base); /// @is {function<void>}
onDespawn = method(id, cbkOnDespawn_base); /// @is {function<void>}
// - Step
onTick = method(id, cbkOnTick_base); /// @is {function<int,void>}
onPostTick = method(id, cbkOnPostTick_base); /// @is {function<int,void>}
onMovement = method(id, cbkOnMovement_base); /// @is {function<void>}
onFrame = method(id, cbkOnFrame_base); /// @is {function<void>}
onFrameEnd = method(id, cbkOnFrameEnd_base); /// @is {function<void>}
// - Attacking
onSetDamage = method(id, cbkOnSetDamage_base); /// @is {function<DamageSource, void>}
onHandleBlock = method(id, cbkOnHandleBlock_base); /// @is {function<DamageSource, void>}
onBlocking = method(id, cbkOnBlocking_base); /// @is {function<DamageSource, void>}
onBlocked = method(id, cbkOnBlocked_base); /// @is {function<DamageSource, void>}
onAttackBegin = method(id, cbkOnAttackBegin_base); /// @is {function<DamageSource, void>}
onAttack = method(id, cbkOnAttack_base); /// @is {function<DamageSource, void>}
onAttackEnd = method(id, cbkOnAttackEnd_base); /// @is {function<DamageSource, void>}
onHurt = method(id, cbkOnHurt_base); /// @is {function<DamageSource, void>}
onDeath = method(id, cbkOnDeath_base); /// @is {function<DamageSource, void>}
// - Drawing
onPreDraw = method(id, cbkOnPreDraw_base); /// @is {function<bool>}
onDraw = method(id, cbkOnDraw_base); /// @is {function<void>}
onPostDraw = method(id, cbkOnPostDraw_base); /// @is {function<void>}

#endregion