var _gameView = game_view();

draw_set_text_align(fa_center, fa_top);
draw_text_transformed(_gameView.center_x(), _gameView.top_edge(16), "Mega Struct\nEngine", 2, 2, 0);

draw_set_text_align(fa_center, fa_bottom);
for (var i = 0; i < optionCount; i++) {
    var _option = options[i],
        _blend = (i == currentOption) ? c_yellow : c_white;
    draw_text_colour(_gameView.center_x(), _gameView.bottom_edge(-16 * (i + 1)), _option[0], _blend, _blend, _blend, _blend, 1);
}

draw_reset_text_align();
