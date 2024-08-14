/// @description Entity Collision
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
if (!place_meeting(x, y, prtEntity))
	exit;

var _entityArr = instance_place_array(x, y, prtEntity, true),
	_numEntities = array_length(_entityArr);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var i = 0;
repeat(_numEntities) {
	var _subject = _entityArr[i];
	if (entity_can_attack_entity(_subject))
		entity_entity_collision(contactDamage, _subject, _subject);
	
	if (!canDealDamage || contactDamage == 0 || entity_is_dead())
		break;
	
	i++;
}