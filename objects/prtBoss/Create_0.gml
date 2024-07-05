event_inherited();

visible = false;

stateMachine = new EntityState("!!Intro_Start");
substate = 0;

animator = new FrameAnimationPlayer(); /// @is {FrameAnimationPlayer}

hudElement = undefined; /// @is {BossHUD?}

// Variables to store various lockpool locks
introLock = undefined; /// @is {PlayerLockStackLock}

// Bool flags for when specific actions are ocurring
isInactive = true;
isIntro = false;
isFinishedSpawn = false;
isFinishedPose = false;
isFillingHealthBar = false;
isFighting = false;

introCache = {}; // Store some variables, so we can restore them after the intro

event_user(EVENT_ANIMATION_INIT);
event_user(EVENT_STATEMACHINE_INIT);