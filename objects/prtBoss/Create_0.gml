event_inherited();

visible = false;

stateMachine = new EntityState();
animator = new FrameAnimationPlayer();
hudElement = new HUDElement_Boss(healthpointsStart, [healthColourPrimary, healthColourSecondary]);
healthbarFiller = new Fractional(healthbarFillRate);
preFightMusicCache = array_create(MusicSnapshot.sizeof);
introCache = {}; // Store some variables, so we can restore them after the intro

// Teleportin'
teleportSprite = sprHotDogTeleport;
teleportImg = 0;
teleportPalette = new ColourPalette([ healthColourPrimary, healthColourSecondary, $000000 ]);

// Variables to store various lockpool locks
introLock = new PlayerLockPoolSwitch(global.player.lockpool,
	PlayerAction.MOVE_FULL, PlayerAction.TURN_FULL,
	PlayerAction.JUMP, PlayerAction.SLIDE,
	PlayerAction.SHOOT, PlayerAction.CHARGE,
	PlayerAction.CLIMB);
introPauseLock = new LockStackSwitch(objSystem.level.pauseStack);

// Bool flags for when specific actions are ocurring
isInactive = true;
isIntro = false;
isTeleporting = false;
isFillingHealthBar = false;
isReady = false;
isFighting = false;

// Callbacks
onSetDamage = method(id, cbkOnSetDamage_prtBoss);
onHurt = method(id, cbkOnHurt_prtBoss);
onDeath = method(id, cbkOnDeath_prtBoss);
onDraw = method(id, cbkOnDraw_prtBoss);

// Event User Inits
event_user(EVENT_BOSS_METHOD_INIT);
event_user(EVENT_BOSS_ANIMATION_INIT);
event_user(EVENT_BOSS_STATEMACHINE_INIT);
