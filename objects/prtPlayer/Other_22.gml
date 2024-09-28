/// @description Animation Init
animator.add_animation_ext("idle", [120, 8])
	.add_property("skinCellX", [0, 1])
	.add_property("skinCellY", [0]);
animator.add_animation_non_loop("sidestep", 1, 8)
	.add_property("skinCellX", [0])
	.add_property("skinCellY", [1]);
animator.add_animation_non_loop("brake", 1, 8)
	.add_property("skinCellX", [0])
	.add_property("skinCellY", [1]);
animator.add_animation("walk", 4, 6.66)
	.add_property("skinCellX", [0, 1, 2, 3])
	.add_property("skinCellY", [2]);
animator.add_animation("jump", 2, 3.33)
	.add_property("skinCellX", [0, 1])
	.add_property("skinCellY", [3]);
animator.add_animation("fall", 2, 3.33)
	.add_property("skinCellX", [2, 3])
	.add_property("skinCellY", [3]);
animator.add_animation("slide", 2, 3.33)
	.add_property("skinCellX", [2, 3])
	.add_property("skinCellY", [0]);
animator.add_animation("climb", 2, 8)
	.add_callback(function(_frame) {
		skinCellX = 1 + _frame;
		skinCellY = 1;
		if (ladderInstance == noone)
			return;
		
		var _ladderTopDistance = (bbox_vertical(-gravDir, ladderInstance) - y) * gravDir;
		if (_ladderTopDistance > 4)
			skinCellX = 3;
	});
animator.add_animation_non_loop("hurt", 1, 8)
	.add_property("skinCellX", [0])
	.add_property("skinCellY", [0])
	.add_property("skinPage", [14]);
animator.add_animation_non_loop("teleport-idle", 1, 8)
	.add_property("skinCellX", [0])
	.add_property("skinCellY", [3])
	.add_property("skinPage", [14]);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("skinCellX", [0, 1, 0, 2])
	.add_property("skinCellY", [3])
	.add_property("skinPage", [14]);