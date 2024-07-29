/// @description Entity Collision
// =====  If the chain is not lethal, =====
// =====  let's save ourselves the hassle and just run the base event =====
if (isChainLethal == "No" || (isChainLethal == "Retract Only" && phase == 3)) {
    event_inherited();
    exit;
}

// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead()) {
	if (!respawn)
		instance_destroy();
	exit;
}

if (global.paused || global.gameTimeScale.integer <= 0)
	exit;

// =====  Entity-to-Entity Collisions =====
if (!canDealDamage || contactDamage == 0)
	exit;

var _entityList = global.__collisionList,
	_numEntities = 0;
	
_numEntities += instance_place_list(x, y, prtEntity, _entityList, true); // The Base
_numEntities += collision_rectangle_list(x - 3, chainStartY, x + 3, chainEndY, prtEntity, true, true, _entityList, true); // The Chain

for (var i = 0; i < _numEntities; ++i) {
	var _subject = _entityList[| i];
	if (entity_can_attack_entity(_subject) && !(_subject.lastHitBy == self && hitTimer <= 0))
		entity_entity_collision(contactDamage, _subject);
}

ds_list_clear(_entityList);