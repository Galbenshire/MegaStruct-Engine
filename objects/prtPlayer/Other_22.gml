/// @description Animation Init

#region Basic Actions

animator.add_animation_ext("idle", [120, 8])
	.add_property("skinSprite", PlayerSpriteType.IDLE)
	.add_property("skinIndex", [0, 1]);
	
animator.add_animation_single_frame("sidestep")
	.add_property("skinSprite", PlayerSpriteType.SIDESTEP)
	.add_property("skinIndex", 0);
	
animator.add_animation_single_frame("brake")
	.add_property("skinSprite", PlayerSpriteType.SIDESTEP)
	.add_property("skinIndex", 0);
	
animator.add_animation("walk", 4, 6.66)
	.add_property("skinSprite", PlayerSpriteType.WALK)
	.add_property("skinIndex", [0, 1, 2, 3]);
	
animator.add_animation("jump", 2, 3.33)
	.add_property("skinSprite", PlayerSpriteType.JUMP)
	.add_property("skinIndex", [0, 1]);
	
animator.add_animation("fall", 2, 3.33)
	.add_property("skinSprite", PlayerSpriteType.FALL)
	.add_property("skinIndex", [0, 1]);
	
animator.add_animation("slide", 2, 3.33)
	.add_property("skinSprite", PlayerSpriteType.SLIDE)
	.add_property("skinIndex", [0, 1]);
	
animator.add_animation("climb", 2, 8)
	.add_property("skinSprite", PlayerSpriteType.CLIMB)
	.add_property("skinIndex", [0, 1]);
	
animator.add_animation_single_frame("climb-top")
	.add_property("skinSprite", PlayerSpriteType.CLIMB_TOP)
	.add_property("skinIndex", 0);

#endregion

#region Hurt/Stun

animator.add_animation_single_frame("hurt")
	.add_property("skinSprite", PlayerSpriteType.HURTSTUN)
	.add_property("skinIndex", 0);

animator.add_animation_single_frame("stun")
	.add_property("skinSprite", PlayerSpriteType.HURTSTUN)
	.add_property("skinIndex", 1);

#endregion

#region Telepor'

animator.add_animation_single_frame("teleport-idle")
	.add_property("skinSprite", PlayerSpriteType.TELEPORT)
	.add_property("skinIndex", 0);

animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("skinSprite", PlayerSpriteType.TELEPORT)
	.add_property("skinIndex", [0, 1, 0, 2]);

#endregion

#region Misc.

animator.add_animation("turnaround", 10, 8)
	.add_property("skinSprite", PlayerSpriteType.TURNAROUND)
	.add_property("skinIndex", array_create_ext(10, function(i) /*=>*/ {return i}));

#endregion