/// @description Animation Init
animator.add_animation_ext("idle", [120, 8])
	.add_property("skinCellX", [0, 1]);
animator.add_animation_non_loop("sidestep", 1, 8)
	.add_property("skinCellX", [2]);
animator.add_animation_non_loop("brake", 1, 8)
	.add_property("skinCellX", [2]);
animator.add_animation("walk", 4, 6.66)
	.add_property("skinCellX", [3, 4, 5, 6]);
animator.add_animation("jump", 2, 3.33)
	.add_property("skinCellX", [7, 8]);
animator.add_animation("fall", 2, 3.33)
	.add_property("skinCellX", [9, 10]);
animator.add_animation("slide", 2, 3.33)
	.add_property("skinCellX", [11, 12]);
animator.add_animation("climb", 2, 8)
	.add_callback(function(_frame) {
		skinCellX = 15 + _frame;
		if (ladderInstance == noone)
			return;
		
		var _ladderTopDistance = (bbox_vertical(-gravDir, ladderInstance) - y) * gravDir;
		if (_ladderTopDistance > 4)
			skinCellX = 17;
	});
animator.add_animation_non_loop("hurt", 1, 8)
	.add_property("skinCellX", [13])
	.add_property("skinCellY", [0]);
animator.add_animation_non_loop("teleport-idle", 1, 8)
	.add_property("skinCellX", [10])
	.add_property("skinCellY", [8]);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("skinCellX", [10, 11, 10, 12])
	.add_property("skinCellY", [8]);