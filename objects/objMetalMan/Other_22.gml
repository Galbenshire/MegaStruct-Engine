/// @description Animation Init
event_inherited();

animator.add_animation_non_loop("!!dropin", 1, 8)
	.add_property("image_index", [8]);
animator.add_animation_non_loop("!!dropin-end", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop_ext("!!pose", [27, 9, 9])
    .add_property("image_index", [0, 2, 3]);

animator.add_animation_ext("idle", [120, 8])
	.add_property("image_index", [0, 1]);
animator.add_animation("walk", 4, 6.66)
	.add_property("image_index", [4, 5, 6, 7]);
animator.add_animation_non_loop("jump", 1, 8)
    .add_property("image_index", [8]);
animator.add_animation_non_loop_ext("blade_throw", [4, 4, 1])
    .add_property("image_index", [9, 10, 8])
    .add_flag(1, "shoot");