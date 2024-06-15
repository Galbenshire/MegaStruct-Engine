/// @func __camera_sync_to_game_view()
/// @desc Sets the camera's position to match what GameView has
function __camera_sync_to_game_view() {
	var _gameView = game_view();
    camera_set_view_pos(view_camera[view_current], _gameView.get_x(), _gameView.get_y());
}

/// @func __camera_debug_free_roam()
/// @desc Moves the camera around freely when the "Free Roam" debug key is enabled
function __camera_debug_free_roam() {
    var _debugSys = objSystem.debug;
    camera_set_view_pos(view_camera[view_current], _debugSys.freeRoamX, _debugSys.freeRoamY);
}
