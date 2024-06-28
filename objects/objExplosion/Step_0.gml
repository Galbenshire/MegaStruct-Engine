/// @description Effect Tick
if (global.paused)
	exit;

repeat(global.gameTimeScale.integer) {
	if (image_index + animSpeed >= image_number) {
		show_debug_message("Spawn item here");
		instance_destroy();
		exit;
	}
	
	image_index += animSpeed;
}
