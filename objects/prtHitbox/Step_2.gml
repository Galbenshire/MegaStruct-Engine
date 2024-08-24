/// @description Entity Collision
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

if (global.paused || global.gameTimeScale.integer <= 0)
	exit;

if (!hitbox_can_deal_damage() || !place_meeting(x, y, [prtEntity, prtHitbox]))
	exit;

var _entityArr = instance_place_array(x, y, [prtEntity, prtHitbox], true),
	_numEntities = array_length(_entityArr);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var i = 0;
repeat(_numEntities) {
	var _subject = _entityArr[i];
	
	if (hitbox_can_attack_target(_subject)) {
		var _subjectEntity = is_object_type(prtHitbox, _subject) ? _subject.owner : _subject;
        entity_entity_collision(owner.contactDamage, _subjectEntity, _subject, owner, self);
	}
	
	if (!hitbox_can_deal_damage() || entity_is_dead(owner))
		break;
	
	i++;
}