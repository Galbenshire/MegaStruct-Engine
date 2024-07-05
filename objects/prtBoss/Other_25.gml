/// @description Boss Posttick
stateMachine.posttick();
stateMachine.update_timer();

animator.update();

if (isFillingHealthBar && !is_undefined(hudElement)) {
	if (!audio_is_playing(sfxEnergyRestore))
		loop_sfx(sfxEnergyRestore);
	
	if (stateMachine.timer mod 3 == 0)
        hudElement.healthpoints = approach(hudElement.healthpoints, healthpoints, 1);
	
	isFillingHealthBar = (healthpoints != hudElement.healthpoints);
	if (!isFillingHealthBar)
		stop_sfx(sfxEnergyRestore);
}