inputs = global.player.inputs;

characterList = array_create_ext(CharacterType.COUNT, function(i) /*=>*/ {return character_create_from_id(i)});
characterIndex = CharacterType.MEGA;
currentCharacter = characterList[characterIndex];

playerX = GAME_WIDTH / 2;
playerY = GAME_HEIGHT / 2;
playerSprite = PlayerSpriteType.IDLE;
playerImgIndex = 0;
playerShootType = PlayerShootType.IDLE;

previewX = 0;
previewY = GAME_HEIGHT - 4;

// == Setup Sprite Names
spriteNames = array_create(PlayerSpriteType.COUNT, "---");
// Standard
spriteNames[PlayerSpriteType.IDLE] = "IDLE";
spriteNames[PlayerSpriteType.SIDESTEP] = "SIDESTEP";
spriteNames[PlayerSpriteType.WALK] = "WALK";
spriteNames[PlayerSpriteType.JUMP] = "JUMP";
spriteNames[PlayerSpriteType.FALL] = "FALL";
spriteNames[PlayerSpriteType.SLIDE] = "SLIDE";
spriteNames[PlayerSpriteType.CLIMB] = "CLIMB";
spriteNames[PlayerSpriteType.CLIMB_TOP] = "CLIMB - TOP";
// Weapons
spriteNames[PlayerSpriteType.BREAK_DASH] = "BREAK DASH";
spriteNames[PlayerSpriteType.SLASH_CLAW] = "SLASH CLAW";
spriteNames[PlayerSpriteType.TENGU_BLADE] = "TENGU BLADE";
spriteNames[PlayerSpriteType.TOP_SPIN] = "TOP SPIN";
// Utilities
spriteNames[PlayerSpriteType.COIL] = "COIL";
spriteNames[PlayerSpriteType.JET] = "JET";
// Misc.
spriteNames[PlayerSpriteType.HURTSTUN] = "HURT/STUN";
spriteNames[PlayerSpriteType.TELEPORT] = "TELEPORT";
spriteNames[PlayerSpriteType.TORNADO_BATTERY] = "TORNADO BATTERY";
spriteNames[PlayerSpriteType.TURNAROUND] = "TURNAROUND";
spriteNames[PlayerSpriteType.WAVE_BIKE] = "WAVE BIKE";
// Indirect
spriteNames[PlayerSpriteType.LIFE] = "LIFE";
spriteNames[PlayerSpriteType.MUGSHOT] = "MUGSHOT";

// == Setup Shoot Type Names
shootTypeNames = array_create(PlayerShootType.COUNT, "---");
shootTypeNames[PlayerShootType.IDLE] = "IDLE";
shootTypeNames[PlayerShootType.SHOOT] = "SHOOT";
shootTypeNames[PlayerShootType.THROW] = "THROW";
shootTypeNames[PlayerShootType.SHOOT_UP] = "SHOOT - UP";
shootTypeNames[PlayerShootType.SHOOT_DIAGONAL_UP] = "SHOOT - DIAG. UP";
shootTypeNames[PlayerShootType.SHOOT_DIAGONAL_DOWN] = "SHOOT - DIAG. DOWN";
shootTypeNames[PlayerShootType.SUPER_ARM] = "SUPER ARM";
shootTypeNames[PlayerShootType.LOOKUP] = "LOOK UP";