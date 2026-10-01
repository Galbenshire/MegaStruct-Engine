/// @description Entity Collision
if (!instance_exists(owner)) {
    instance_destroy();
    exit;
}

var _collisionPauseMask = owner.pauseMask & PauseType.GAMEPLAY;
_collisionPauseMask = bitmask_unset_bit(_collisionPauseMask, PauseType.SECTION_SWITCH);
if (!game_can_step(_collisionPauseMask) || !hitbox_can_deal_damage() || !place_meeting(x, y, [prtEntity, prtHitbox]))
	exit;

var _entityArr = instance_place_array(x, y, [prtEntity, prtHitbox], true);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var _damageSource = new DamageSource(self.id, self.id, owner.contactDamage);
var i = 0; repeat(array_length(_entityArr)) {
	_damageSource.set_subject(_entityArr[i]);
	_damageSource.refresh_state(owner.contactDamage);
	_damageSource.process_attack();
	
	if (!hitbox_can_deal_damage() || entity_is_dead(owner))
		break;
	
	i++;
}
delete _damageSource;