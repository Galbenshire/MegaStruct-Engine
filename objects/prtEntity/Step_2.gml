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
if (!entity_can_deal_damage(true) || !place_meeting(x, y, [prtEntity, prtHitbox]))
	exit;

var _entityArr = instance_place_array(x, y, [prtEntity, prtHitbox], true),
	_numEntities = array_length(_entityArr);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var i = 0;
repeat(_numEntities) {
	var _subject = _entityArr[i];
	
	if (entity_can_attack_target(_subject)) {
		var _subjectEntity = is_object_type(prtHitbox, _subject) ? _subject.owner : _subject;
		entity_entity_collision(contactDamage, _subjectEntity, _subject);
	}
	
	if (!entity_can_deal_damage())
		break;
	
	i++;
}