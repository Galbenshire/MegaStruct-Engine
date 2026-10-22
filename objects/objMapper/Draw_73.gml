if (!surface_exists(mapSurface)) {
    mapSurface = surface_create(mapSurfaceWidth, mapSurfaceHeight);
    mapSurfaceRefresh = true;
}
if (mapSurfaceRefresh)
    event_user(1);

var _gameView = game_view(),
    _viewX = _gameView.get_x(),
    _viewY = _gameView.get_y();

// The Map
draw_surface(mapSurface, _viewX + 16, _viewY + 16);

// Map Info
draw_sprite_ext(sprDot, 0, _viewX + 16 + mapSurfaceWidth, _viewY + 16, 80, mapSurfaceHeight, 0, c_gray, 0.9);
draw_set_text_align(fa_left, fa_top);
draw_text(_viewX + 20 + mapSurfaceWidth, _viewY + 20, $"Map Size:\nW {mapWidth}\nH {mapHeight}");
draw_reset_text_align();

// Checkpoint Info
if (checkpointDataCount > 0) {
    var _checkpoint = checkpointData[currentCheckpoint];
    draw_sprite_ext(sprDot, 0, _viewX + 16, _viewY + 16 + mapSurfaceHeight, mapSurfaceWidth, 32, 0, c_gray, 0.9);
    draw_set_text_align(fa_left, fa_top);
    draw_text_transformed(_viewX + 20, _viewY + mapSurfaceHeight + 20, $"Selected Checkpoint:\n{_checkpoint[CheckpointData.name]}", 0.5, 0.5, 0);
    draw_reset_text_align();
}