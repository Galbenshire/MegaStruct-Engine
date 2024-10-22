event_inherited();

fireDurationList = [15, 35, 55];
fireDuration = 0;
tailTimer = 0;
tailImgIndex = 0;
shootFlag = false;

// Callbacks
onDeath = function(_damageSource) {
	if (stateMachine.get_current_state() == "Dying")
		cbkOnDeath_prtBoss(_damageSource);
	else
		stateMachine.change_state("Dying");
};
onDraw = function(_whiteflash) {
	if (isTeleporting) {
		cbkOnDraw_prtBoss(_whiteflash);
	} else {
		draw_self();
		draw_sprite_ext(sprHotDogTail, tailImgIndex, x - 24 * image_xscale, y - 21 * image_yscale, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
};