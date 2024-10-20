/// @description Animation Init
animator.add_animation_non_loop("!!teleport-idle", 1, 8)
	.add_property("teleportImg", [0]);
animator.add_animation_non_loop("!!teleport-in", 4, 3)
	.add_property("teleportImg", [0, 1, 0, 2]);