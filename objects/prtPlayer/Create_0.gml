event_inherited();

mask_index = maskNormal;

// Weapons
weapon = undefined; /// @is {Weapon}
loadout = []; /// @is {array<Weapon>}
loadoutSize = 0;

// Animation System
animator = new FrameAnimationPlayer(); /// @is {FrameAnimationPlayer}

// State Machine
stateMachine = new EntityState("Idle");

// Player stuff
playerID = -1; // Which player is controlling this object
playerUser = undefined; /// @is {Player} A reference to the player struct using this as a body. If `undefined`, it's not controlled by a player

// Input
inputs = new InputMap();
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

// Shooting
shootTimer = 0;
shootAnimation = 0;
autoFireTimer = 0;

// Weapon Switching
quickSwitchTimer = 0; /// @is {int}
weaponIconTimer = 0; /// @is {int}

// Flag for if the player died by falling down a pit
// (to skip the delay & explosions)
canDieToPits = true;
diedToAPit = false;

// Player Spritesheet
skinCellX = 0;
skinCellY = 0;

// Palettes
palette = new ColourReplacer(
	input_palette_player(),
	player_get_character().get_colours()
);
paletteCache = variable_clone(palette);

// Lock Pool
lockpool = new PlayerLockPool();
introLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT, PlayerAction.CHARGE);
slideLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT);
shootStandStillLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.MOVE_GROUND, PlayerAction.TURN_GROUND); // This lock is for staying on the ground after using a weapon like Metal Blade
hitstunLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT);
pauseLock = new LockStackSwitch(objSystem.level.pauseStack);
freeMovementLock = new PlayerLockPoolSwitch(lockpool, PlayerAction.SHOOT, PlayerAction.CHARGE, PlayerAction.PHYSICS, PlayerAction.SPRITE_CHANGE, PlayerAction.WEAPON_CHANGE);

// Bool flags for when specific actions are ocurring
// Makes it easier to check if the player is performing a specific action
isIntro = false;
isSliding = false;
isClimbing = false;
isShooting = false;
isCharging = false;
isHurt = false;
isFreeMovement = false;

// temp vars
ignoreCamera = false;

// Callbacks
onSpawn = method(id, cbkOnSpawn_prtPlayer); /// @is {function<void>}
onDespawn = method(id, cbkOnDespawn_prtPlayer); /// @is {function<void>}
onSetDamage = method(id, cbkOnSetDamage_prtPlayer); /// @is {function<DamageSource, void>}
onHurt = method(id, cbkOnHurt_prtPlayer); /// @is {function<DamageSource, void>}
onDeath = method(id, cbkOnDeath_prtPlayer); /// @is {function<DamageSource, void>}
onDraw = method(id, cbkOnDraw_prtPlayer); /// @is {function<bool, void>}

// Event User Inits
event_user(EVENT_ANIMATION_INIT);
event_user(EVENT_STATEMACHINE_INIT);