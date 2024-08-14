/// @description Entity Collision
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

if (global.paused || global.gameTimeScale.integer <= 0)
	exit;

if (!active || !canDealDamage || owner.contactDamage == 0)
	exit;
if (!place_meeting(x, y, prtEntity))
	exit;

var _entityArr = instance_place_array(x, y, prtEntity, true),
	_numEntities = array_length(_entityArr);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var i = 0;
repeat(_numEntities) {
	var _subject = _entityArr[i];
	
	var _result = _subject.canTakeDamage && _subject.iFrames == 0 && _subject.hitTimer >= owner.attackDelay
		&& !entity_is_dead(_subject) && (owner.factionMask & _subject.factionLayer > 0);
	if (_result)
        entity_entity_collision(owner.contactDamage, _subject, _subject, owner, self);
	
	if (!canDealDamage || owner.contactDamage == 0 || entity_is_dead(owner))
		break;
	
	i++;
}