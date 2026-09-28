/// @description Animation Init
animator.add_animation_single_frame("!!teleport-idle")
	.add_property("teleportImg", 0);
animator.add_animation_non_loop("!!teleport-in", 4, 3)
	.add_property("teleportImg", [0, 1, 0, 2]);

animator.add_animation_single_frame("!!dropin")
	.add_property("image_index", 0);
animator.add_animation_single_frame("!!dropin-end")
	.add_property("image_index", 0);

animator.add_animation_single_frame("!!pose")
	.add_property("image_index", 0);