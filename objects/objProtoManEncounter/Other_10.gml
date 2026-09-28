/// @description Animation Init
animator.add_animation_single_frame("teleport-idle")
	.add_property("image_index", 2);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("image_index", [2, 3, 2, 4]);
animator.add_animation_non_loop("teleport-out", 4, 3)
	.add_property("image_index", [4, 2, 3, 2]);

animator.add_animation_single_frame("idle")
	.add_property("image_index", 0);
animator.add_animation_single_frame("idle-scarfless")
	.add_property("image_index", 1);