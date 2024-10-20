/// @description Boss Posttick
stateMachine.posttick();
stateMachine.update_timer();

animator.update();

if (isFillingHealthBar) {
	if (!audio_is_playing(sfxEnergyRestore))
		loop_sfx(sfxEnergyRestore);
	
	if (hudElement.healthpoints > FULL_HEALTHBAR)
		healthbarFiller.value += healthbarFillAccel;
	healthbarFiller.update();
	hudElement.healthpoints = approach(hudElement.healthpoints, healthpoints, healthbarFiller.integer);
	isFillingHealthBar = (healthpoints != hudElement.healthpoints);
	
	if (!isFillingHealthBar)
		stop_sfx(sfxEnergyRestore);
}