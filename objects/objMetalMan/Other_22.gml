/// @description Animation Init
animator.add_animation_non_loop("!!intro_spawn_dropin", 1, 8)
    .add_property("image_index", [8]);
animator.add_animation_non_loop_ext("!!intro_pose", [27, 9, 32])
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