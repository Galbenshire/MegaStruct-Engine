exit;

var _gameView = game_view();

var _str = $"{animator.currentAnimationName}\n{animator.currentFrame}\n{animator.is_animation_finished()}";

var _boxWidth = (string_width(_str) * 0.5) + 8,
    _boxHeight = (string_height(_str) * 0.5) + 8;

draw_set_text_align(fa_left, fa_top);
draw_sprite_ext(sprDot, 0, game_view().left_edge(0), game_view().top_edge(0), _boxWidth, _boxHeight, 0, c_black, 0.75);
draw_text_transformed(game_view().left_edge(4), game_view().top_edge(4), _str, 0.5, 0.5, 0);
draw_reset_text_align();
