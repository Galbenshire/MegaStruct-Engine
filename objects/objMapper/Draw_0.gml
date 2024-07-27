if (!surface_exists(mapSurface)) {
    mapSurface = surface_create(mapWidth, mapHeight);
    mapSurfaceRefresh = true;
}
if (mapSurfaceRefresh)
    event_user(1);

var _gameView = game_view(),
    _viewX = _gameView.get_x(),
    _viewY = _gameView.get_y();

draw_surface(mapSurface, _viewX + 16, _viewY + 16);

if (checkpointDataCount > 0) {
    var _checkpoint = checkpointData[currentCheckpoint],
        _str = string("Selected Checkpoint:\n{0}", _checkpoint[CheckpointData.name]);
    
    draw_sprite_ext(sprDot, 0, _viewX + 16, _viewY + 16 + mapHeight, mapWidth, 32, 0, c_gray, 0.9);
    draw_set_text_align(fa_left, fa_top);
    draw_text(_viewX + 20, _viewY + mapHeight + 20, _str);
    draw_reset_text_align();
}