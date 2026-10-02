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

// (for if you choose teleporting as an intro type)
teleportRef = noone;
teleportSFX = noone;

// Variables to store various lockpool locks
introLock = new PlayerLockPoolSwitch(global.player.lockpool, PlayerAction.SHOOT);
introPauseLock = new LockStackSwitch(PAUSE_STACK);

// Bool flags for when specific actions are ocurring
isInactive = true;
isIntro = false;
isFillingHealthBar = false;
isReady = false;
isFighting = false;

iFrameFlashStyle = IFrameFlashType.HITSPARK;

#endregion

#region Callbacks

onDespawn = method(id, cbkOnDespawn_boss);
onSetDamage = method(id, cbkOnSetDamage_boss);
onHurt = method(id, cbkOnHurt_boss);
onDeath = method(id, cbkOnDeath_boss);

#endregion

#region Event User Inits

event_user(EVENT_BOSS_METHOD_INIT);
event_user(EVENT_BOSS_ANIMATION_INIT);
event_user(EVENT_BOSS_STATEMACHINE_INIT);

#endregion