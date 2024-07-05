if (global.paused || !canDealDamage || global.gameTimeScale.integer <= 0)
    exit;

var _entityList = global.__collisionList,
	_numEntities = collision_rectangle_list(boundsLeft, boundsTop, boundRight, boundBottom, prtPlayer, false, true, _entityList, true);

for (var i = 0; i < _numEntities; ++i) {
	target = _entityList[| i];
	event_user(0);
}

ds_list_clear(_entityList);