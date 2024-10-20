event_inherited();

// Callbacks
onDraw = function(_whiteflash) {
	if (isTeleporting) {
		cbkOnDraw_prtBoss(_whiteflash);
	} else {
		draw_self();
    	draw_sprite_ext(sprHotDogTail, 0, x - 24 * image_xscale, y - 21 * image_yscale, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
	draw_text(x, y, isTeleporting);
}