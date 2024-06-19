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
coyoteTimer = 0;
jumpBufferTimer = 0;

// Sliding
slideMaskHeightDelta = abs(sprite_get_bbox_height(maskNormal) - sprite_get_bbox_height(maskSlide)); /// @is {number}

// Player Spritesheet
skinSprite = sprPlayerSkinRockMan;
skinCellX = 0;
skinCellY = 0;

// Palette
bodyPalette = new ColourReplacer(
	[ $EC7000, $F8B838, $9858F8 ],
	[ $EC7000, $F8B838, $000000 ]
);

// Bool flags for when specific actions are ocurring
// Makes it easier to check if the player is performing a specific action
isIntro = false;
isSliding = false;
isClimbing = false;
isShooting = false;

// Event User Inits
event_user(EVENT_ANIMATION_INIT);
event_user(EVENT_STATEMACHINE_INIT);