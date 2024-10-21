/// @description Animation Init
event_inherited();

animator.add_animation_non_loop("!!dropin", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop("!!dropin-end", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop_ext("!!pose", [15, 2, 3, 5, 2, 3, 5, 2, 3, 10])
	.add_property("image_index", [0, 1, 2, 0, 1, 2, 0, 1, 2, 0]);
animator.add_animation_non_loop_ext("main", [15, 2, 3, 5, 2, 3, 5, 2, 3, 25, 2])
	.add_property("image_index", [0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 3])
	.add_flag(10, "shoot");