event_inherited();

mask_index = maskNormal;

#region Variables

// Character Specs (i.e. details about the playable character represented by this object)
characterSpecs = character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

// Weapons
weapon = new Weapon_MegaBuster(); /// @is {Weapon}
weaponList = [weapon]; /// @is {array<Weapon>}
weaponSize = 1;

// Animation System
animator = new FrameAnimationPlayer();

// State Machine
stateMachine = new StateStacker("StandardGround", true);
//stateMachine.loggingEnabled = true;

// Player stuff
playerID = -1; // Which player is controlling this object
playerUser = undefined; /// @is {Player} A reference to the player struct using this as a body. If `undefined`, it's not controlled by a player

// Input
manualInputs = new InputMap();
userInputs = new InputMap();
xDir = 0;
yDir = 0;

// Jump stuff
canMinJump = false; // Allows the player to cut their jump by releasing the jump button
coyoteTimer = 0;
jumpBufferTimer = 0;
midairJumps = 0;

// Sliding
slideMaskHeightDelta = abs(sprite_get_bbox_height(maskNormal) - sprite_get_bbox_height(maskSlide)); /// @is {number}
slideBoostActive = false;

// Climbing
jumpedOffLadder = false;

// Shooting
shootTimer = 0;
shootType = PlayerShootType.IDLE;
autoFireTimer = 0;

// Weapon Switching
quickSwitchTimer = 0; /// @is {int}
weaponIconTimer = 0; /// @is {int}

// Flag for if the player died by falling down a pit
// (to skip the delay & explosions)
canDieToPits = true;

// Teleporting In/Out
teleportInType = TeleportInType.TELEPORT_LONG;
teleportOutType = TeleportOutType.TELEPORT_LONG;
teleportX = x;
teleportY = y;

// Player Sprite
skinSprite = PlayerSpriteType.IDLE;
skinIndex = 0;
skinOffset = 0;

// Palette
palette = new ColourPalette(characterSpecs.get_player_colours(true));

// HUD
hudElement = new HUDElement_Player();

// Lock Pool
lockpool = new PlayerLockPool();
inactiveLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT, PlayerAction.CHARGE, PlayerAction.PHYSICS, PlayerAction.SPRITE_CHANGE, PlayerAction.WEAPON_CHANGE);
teleportLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT, PlayerAction.CHARGE, PlayerAction.GRAVITY);
slideLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT);
shootStandStillLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.MOVE_GROUND, PlayerAction.TURN_GROUND);
hitstunLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT);
freeMovementLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT, PlayerAction.CHARGE, PlayerAction.PHYSICS, PlayerAction.SPRITE_CHANGE, PlayerAction.WEAPON_CHANGE);
pauseLock = new LockStackSwitch(PAUSE_STACK);

// Bool flags for when specific actions are ocurring
// Makes it easier to check if the player is performing a specific action
isInactive = false;
isTeleporting = false;
isSliding = false;
isClimbing = false;
isShooting = false;
isCharging = false;
isHurt = false;
isFreeMovement = false;

// Misc.
iFrameFlashStyle = IFrameFlashType.FLICKER;

// temp vars
ignoreCamera = false;

#endregion

#region Callbacks

// - Spawning
onSpawn = method(id, cbkOnSpawn_player); /// @is {function<void>}
onDespawn = method(id, cbkOnDespawn_player); /// @is {function<void>}
// - Step
onPostTick = method(id, cbkOnPostTick_player); /// @is {function<int,void>}
onMovement = method(id, cbkOnMovement_player); /// @is {function<void>}
onFrame = method(id, cbkOnFrame_player); /// @is {function<void>}
onFrameEnd = method(id, cbkOnFrameEnd_player); /// @is {function<void>}
// - Attacking
onSetDamage = method(id, cbkOnSetDamage_player); /// @is {function<DamageSource, void>}
onHurt = method(id, cbkOnHurt_player); /// @is {function<DamageSource, void>}
onDeath = method(id, cbkOnDeath_player); /// @is {function<DamageSource, void>}
// - Drawing
onDraw = method(id, cbkOnDraw_player); /// @is {function<bool, void>}

#endregion

#region Event User Inits

event_user(EVENT_PLAYER_METHOD_INIT);
event_user(EVENT_PLAYER_ANIMATION_INIT);
event_user(EVENT_PLAYER_STATEMACHINE_INIT);

#endregion