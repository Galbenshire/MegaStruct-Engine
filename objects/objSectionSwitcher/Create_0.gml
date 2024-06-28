// State Machine
stateMachine = new SnowState("_DeferPause");
stateTimer = 0;
// Movement
xspeed = new Fractional();
yspeed = new Fractional();
// Object References
playerInstance = noone; /// @is {prtPlayer}
transitionInstance = noone;  /// @is {objScreenTransition}
targetSection = noone; /// @is {objSection}
// A copy of the player's speed
playerXSpeedCache = 0;
playerYSpeedCache = 0;
// Some player animations persist through the switch
persistentAnimations = ["walk", "climb"]; /// @is {array<string>}
animatePlayer = false;
// Details about the direction of the switch
isVerticalTransition = false;
transitionXDir = 0;
transitionYDir = 0;
// Details about the velocity of the screen when switching
screenScrollXSpeed = 0;
screenScrollYSpeed = 0;
// Details about the velocity of the player when switching
playerMoveXSpeed = 0;
playerMoveYSpeed = 0;
// Details about the direction the screen moves in when fixing misalignments
alignmentFixXDir = 0;
alignmentFixYDir = 0;
// Reference to the game view
gameViewRef = game_view();

event_user(EVENT_STATEMACHINE_INIT);