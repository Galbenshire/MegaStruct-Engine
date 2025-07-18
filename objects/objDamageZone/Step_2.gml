if (!game_can_step() || !canDealDamage)
    exit;

var _entitiesArr = collision_rectangle_array(boundsLeft, boundsTop, boundRight, boundBottom, prtPlayer, false, true, true),
	_numEntities = array_length(_entitiesArr);

var i = 0;
repeat(_numEntities) {
	target = _entitiesArr[i];
	event_user(0);
	i++;
}