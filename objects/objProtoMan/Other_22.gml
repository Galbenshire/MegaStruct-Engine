/// @description Animation Init
event_inherited();

// Override select animations
animator.add_animation("idle", 2, 8)
	.add_property("skinIndex", [0, 1]);