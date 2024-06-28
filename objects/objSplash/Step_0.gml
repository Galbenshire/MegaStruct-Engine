if (global.paused)
	exit;
	
repeat(global.gameTimeScale.integer) {
	if (image_index + animSpeed >= image_number) {
		instance_destroy();
		exit;
	}
	
	image_index += animSpeed;
}
