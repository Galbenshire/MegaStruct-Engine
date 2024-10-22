/// @description Animation Init
event_inherited();

animator.add_animation_non_loop("!!dropin", 1, 8)
	.add_property("image_index", [10]);
animator.add_animation_non_loop("!!dropin-end", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop("!!pose", 9, 3.75)
    .add_property("image_index", [0, 1, 1, 2, 2, 2, 3, 4, 2]);

animator.add_animation_non_loop("idle", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop("jump", 1, 8)
	.add_property("image_index", [10]);
animator.add_animation("run", 4, 4.75)
	.add_property("image_index", [5, 6, 7, 8]);
animator.add_animation_non_loop("shoot", 3, 5)
	.add_property("image_index", [1, 9, 9])
	.add_flag(1, "shoot");