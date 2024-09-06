/// @description Effect Tick
if (global.paused)
	exit;

repeat(global.gameTimeScale.integer) {
	if (image_index + animSpeed >= image_number) {
		event_user(0);
		instance_destroy();
		exit;
	}
	
	image_index += animSpeed;
}