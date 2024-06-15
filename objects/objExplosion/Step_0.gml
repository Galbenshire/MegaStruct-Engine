/// @description Effect Tick
if (global.paused)
	exit;

if (image_index + (animSpeed * global.gameTimeScale.integer) >= image_number) {
	show_debug_message("Spawn item here");
	
	instance_destroy();
	exit;
}

event_inherited();
