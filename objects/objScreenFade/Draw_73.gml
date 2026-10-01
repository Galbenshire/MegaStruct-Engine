if (fadeAlpha > 0) {
    var _alpha = (fadeStep > 0) ? round_to(fadeAlpha, fadeStep) : fadeAlpha;
    draw_rectangle_solid(game_view().get_x(), game_view().get_y(), GAME_WIDTH, GAME_HEIGHT, fadeColour, _alpha);
}
