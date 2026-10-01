var _collisionPauseMask = PauseType.PAUSEMENU | PauseType.TIMESCALE | PauseType.HITSTUN;
if (!game_can_step(_collisionPauseMask) || !canDealDamage)
    exit;

var _entitiesArr = collision_rectangle_array(boundsLeft, boundsTop, boundRight, boundBottom, prtPlayer, false, true, true);
var i = 0; repeat(array_length(_entitiesArr)) {
	target = _entitiesArr[i];
	event_user(0);
	i++;
}