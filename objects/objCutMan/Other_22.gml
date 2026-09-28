/// @description Animation Init
event_inherited();

animator.add_animation_single_frame("!!dropin")
	.add_property("image_index", 2);
animator.add_animation_single_frame("!!dropin-end")
	.add_property("image_index", 0);
animator.add_animation_non_loop("!!pose", 9, 10)
    .add_property("image_index", [0, 1, 0, 1, 0, 1, 0, 1, 0]);

animator.add_animation("walk", 4, 6.66)
	.add_property("image_index", [3, 4, 5, 6]);
animator.add_animation_single_frame("jump")
    .add_property("image_index", 2);
animator.add_animation("cutter-pose", 2, 10)
	.add_property("image_index", [0, 1]);
animator.add_animation_non_loop("cutter-throw", 2, 16.5)
    .add_property("image_index", [7, 8])
    .add_flag(1, "shoot");
animator.add_animation_single_frame("hurt")
    .add_property("image_index", 4);