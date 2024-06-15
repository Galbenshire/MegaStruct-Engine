/// @description Entity Collision
// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead()) {
	if (!respawn)
		instance_destroy();
	exit;
}

if (global.paused)
	exit;

// =====  Entity-to-Entity Collisions =====
if (!canDealDamage || contactDamage == 0)
	exit;
if (!place_meeting(x, y, prtEntity))
	exit;

var _entityList = global.__collisionList,
	_numEntities = instance_place_list(x, y, prtEntity, _entityList, true);

for (var i = 0; i < _numEntities; ++i) {
	var _subject = _entityList[| i];
	if (entity_can_attack_entity(_subject))
		entity_entity_collision(contactDamage, _subject);
}

ds_list_clear(_entityList);