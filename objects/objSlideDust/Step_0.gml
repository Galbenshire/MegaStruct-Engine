if (global.paused)
	exit;

var _gameTicks = global.gameTimeScale.integer;
if (image_index + (animSpeed * _gameTicks) >= image_number) {
	instance_destroy();
	exit;
}

event_inherited();
