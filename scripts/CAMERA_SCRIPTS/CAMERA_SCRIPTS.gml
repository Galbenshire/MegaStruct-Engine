/// @func __camera_sync_to_game_view()
/// @desc Sets the camera's position to match what GameView has
function __camera_sync_to_game_view() {
	var _gameView = game_view(),
		_camX = _gameView.get_x(),
		_camY = _gameView.get_y();
	
	camera_set_view_pos(view_camera[view_current], _camX, _camY);
	camera_set_view_size(view_camera[view_current], GAME_WIDTH, GAME_HEIGHT);
}

/// @func __camera_debug_free_roam()
/// @desc Moves the camera around freely when the "Free Roam" debug key is enabled
function __camera_debug_free_roam() {
    var _debugSys = objSystem.debug,
		_camX = _debugSys.freeRoamX,
		_camY = _debugSys.freeRoamY;
	
    if (_debugSys != 1) {
		var _zoom = _debugSys.freeRoamZoom,
			_zoomedWidth = GAME_WIDTH / _zoom,
			_zoomedHeight = GAME_HEIGHT / _zoom;
		camera_set_view_size(view_camera[view_current], _zoomedWidth, _zoomedHeight);
    }
    
    camera_set_view_pos(view_camera[view_current], _camX, _camY);
}
