event_inherited();

visible = false;

#region Variables

stateMachine = new StateStacker("!!Inactive", true);
stateMachine.loggingEnabled = true;
animator = new FrameAnimationPlayer();
hudElement = new HUDElement_Boss(healthpointsStart, [healthColourPrimary, healthColourSecondary]);
healthbarFiller = new Fractional(healthbarFillRate);
introCache = {}; // Store some variables, so we can restore them after the intro
customIntroSequence = [];

preFightMusicCache = array_create(MusicSnapshot.sizeof);
preFightMusicCache[MusicSnapshot.musicID] = -1;

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

#endregion

#region Callbacks

onSetDamage = method(id, cbkOnSetDamage_prtBoss);
onHurt = method(id, cbkOnHurt_prtBoss);
onDeath = method(id, cbkOnDeath_prtBoss);
onDraw = method(id, cbkOnDraw_prtBoss);

#endregion

#region Event User Inits

event_user(EVENT_BOSS_METHOD_INIT);
event_user(EVENT_BOSS_ANIMATION_INIT);
event_user(EVENT_BOSS_STATEMACHINE_INIT);

#endregion