/// @description Entity Collision
// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead()) {
	if (!entity_can_respawn())
		instance_destroy();
	exit;
}

// =====  Entity-to-Entity Collisions =====
if (!game_can_step() || !entity_can_deal_damage() || !place_meeting(x, y, [prtEntity, prtHitbox]))
	exit;

var _entityArr = instance_place_array(x, y, [prtEntity, prtHitbox], true);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var _damageSource = new DamageSource(self.id, self.id, contactDamage);
var i = 0; repeat(array_length(_entityArr)) {
	if (instance_exists(_entityArr[i])) {
		_damageSource.set_subject(_entityArr[i]);
		_damageSource.refresh_state(contactDamage);
		_damageSource.process_attack();
	}
	
	if (!entity_can_deal_damage())
		break;
	i++;
}
delete _damageSource;