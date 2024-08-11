/// @description Animation Init
event_inherited();

// Override select animations
animator.add_animation("idle", 2, 8)
	.add_property("skinCellX", [0, 1]);
animator.add_animation("jump", 2, 3.33)
	.add_property("skinCellX", [7, 8])
	.add_callback(function(_frame) {
		if (shootAnimation == 0) {
			skinCellX++;
			skinCellY = 12;
		}
	});
animator.add_animation("fall", 2, 3.33)
	.add_property("skinCellX", [9, 10])
	.add_callback(function(_frame) {
		if (shootAnimation == 0) {
			skinCellX++;
			skinCellY = 12;
		}
	});
