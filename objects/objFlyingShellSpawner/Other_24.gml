/// @description Perform Interval Action
var _gameView = game_view(),
    _spawn_x = (spawnDir > 0) ? _gameView.left_edge() : _gameView.right_edge(),
    _spawn_y = y;

lastSpawnedShell = spawn_entity(_spawn_x, _spawn_y, depth, objFlyingShell);
lastSpawnedShell.respawn = false;
lastSpawnedShell.moveSpeed = shellMoveSpeed;
lastSpawnedShell.bulletSpeed = shellBulletSpeed;
lastSpawnedShell.bulletCount = shellBulletCount;
