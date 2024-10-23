// The Proto Man encounter from MM3 & MMV

whistleSFX = sfxProtoWhistle;
animator = new FrameAnimationPlayer();
stateMachine = new EntityState();

// Variables to store various lockpool locks
encounterLock = new PlayerLockPoolSwitch(global.player.lockpool,
	PlayerAction.MOVE, PlayerAction.TURN,
	PlayerAction.JUMP, PlayerAction.SLIDE,
	PlayerAction.SHOOT, PlayerAction.CHARGE,
	PlayerAction.CLIMB);
encounterPauseLock = new LockStackSwitch(objSystem.level.pauseStack);

// Callback - set this to determine what happens when Proto Man goes away
onEncounterEnd = undefined; /// @is {function<void>?}
__encounterIsOver = false;

event_user(EVENT_ANIMATION_INIT);
event_user(EVENT_STATEMACHINE_INIT);