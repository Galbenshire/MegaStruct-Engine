// The Proto Man encounter from MM3 & MMV

animator = new FrameAnimationPlayer();
stateMachine = new StateStacker("Inactive", true);
whistleSFX = sfxProtoWhistle;
idleAnim = "idle";

// Variables to store various lockpool locks
encounterLock = new PlayerLockPoolSwitch(global.player.lockpool, PlayerAction.SHOOT);
encounterPauseLock = new LockStackSwitch(PAUSE_STACK);

// Callback - set this to determine what happens when Proto Man goes away
onEncounterEnd = undefined; /// @is {function<void>?}

event_user(0); // Animation Init
event_user(1); // State Machine Init