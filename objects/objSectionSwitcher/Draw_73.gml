if (image_alpha <= 0)
	exit;

draw_rectangle_solid(gameViewRef.get_x(), gameViewRef.get_y(), GAME_WIDTH, GAME_HEIGHT, c_black, image_alpha);
with (playerInstance) {
	event_perform(ev_draw, ev_draw_normal);
	event_perform(ev_draw, ev_draw_end);
}