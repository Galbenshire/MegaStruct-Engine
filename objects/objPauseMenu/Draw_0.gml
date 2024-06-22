var _gameView = game_view();
draw_sprite_ext(sprDot, 0, _gameView.get_x(), _gameView.get_y(), GAME_WIDTH, GAME_HEIGHT, 0, c_gray, 0.5);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_gameView.center_x(), _gameView.center_y(), "-- PAUSE --");
draw_reset_text_align();
