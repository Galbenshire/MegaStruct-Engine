event_inherited();

fireDurationList = [20, 40, 60];
fireDuration = 0;
tailTimer = 0;
tailImgIndex = 0;
shootFlag = false;

// Callbacks
onDraw = function(_whiteflash) {
	if (isTeleporting) {
		cbkOnDraw_prtBoss(_whiteflash);
	} else {
		draw_self();
    	draw_sprite_ext(sprHotDogTail, tailImgIndex, x - 24 * image_xscale, y - 21 * image_yscale, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
}
