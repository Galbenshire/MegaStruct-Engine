event_inherited();

mask_index = maskNormal;

// State Machine
stateMachine = new EntityState("Idle");

// Player stuff
playerID = -1; // Which player is controlling this object
player = undefined; /// @is {Player?} A reference to the player struct using this as a body. If `undefined`, it's not controlled by a player

// Input
inputs = new InputMap();
xDir = 0;
yDir = 0;

// Jump stuff
canMinJump = false; // Allows the player to cut their jump by releasing the jump button

// Sliding
slideMaskHeightDelta = abs(sprite_get_bbox_height(maskNormal) - sprite_get_bbox_height(maskSlide)); /// @is {number}

// Event User Inits
event_user(EVENT_STATEMACHINE_INIT);