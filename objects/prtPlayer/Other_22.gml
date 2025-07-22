/// @description Animation Init
// -- Basic Actions
animator.add_animation_ext("idle", [120, 8])
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_IDLE, PLAYER_ANIM_FRAME_IDLE + 1]);
animator.add_animation_non_loop("sidestep", 1, 8)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_SIDESTEP]);
animator.add_animation_non_loop("brake", 1, 8)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_SIDESTEP]);
animator.add_animation("walk", 4, 6.66)
	.add_property("skinIndex", array_create_ext(4, function(i) /*=>*/ {return PLAYER_ANIM_FRAME_WALK + i}));
animator.add_animation("jump", 2, 3.33)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_JUMP, PLAYER_ANIM_FRAME_JUMP + 1]);
animator.add_animation("fall", 2, 3.33)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_FALL, PLAYER_ANIM_FRAME_FALL + 1]);
animator.add_animation("slide", 2, 3.33)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_SLIDE, PLAYER_ANIM_FRAME_SLIDE + 1]);
animator.add_animation("climb", 2, 8)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_CLIMB, PLAYER_ANIM_FRAME_CLIMB + 1]);
animator.add_animation_non_loop("climb-top", 1, 8)
	.add_property("skinIndex", [PLAYER_ANIM_FRAME_CLIMB + 2]);
// -- Hurt / Stun
animator.add_animation_non_loop("hurt", 1, 8)
	.add_property("skinSprite", [PlayerAnimationType.HURTSTUN])
	.add_property("skinIndex", [0]);
animator.add_animation_non_loop("stun", 1, 8)
	.add_property("skinSprite", [PlayerAnimationType.HURTSTUN])
	.add_property("skinIndex", [1]);
// -- Telepor'
animator.add_animation_non_loop("teleport-idle", 1, 8)
	.add_property("skinSprite", [PlayerAnimationType.TELEPORT])
	.add_property("skinIndex", [0]);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("skinSprite", [PlayerAnimationType.TELEPORT])
	.add_property("skinIndex", array_create_ext(4, function(i) /*=>*/ {return ((i/2) + 0.5) * (i & 1)})); //[0, 1, 0, 2]
// -- Rotat e
animator.add_animation("turnaround", 10, 8)
	.add_property("skinSprite", [PlayerAnimationType.TURNAROUND])
	.add_property("skinIndex", array_create_ext(10, function(i) /*=>*/ {return i}));