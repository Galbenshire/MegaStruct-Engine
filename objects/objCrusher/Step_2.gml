/// @description Entity Collision
// =====  If the chain is not lethal, =====
// =====  let's save ourselves the hassle and just run the base event =====
if (isChainLethal == "No" || (isChainLethal == "Retract Only" && phase == 3)) {
    event_inherited();
    exit;
}

// =====  Destroy if dead & unable to respawn =====
if (entity_is_dead()) {
	if (!entity_can_respawn())
		instance_destroy();
	exit;
}

// =====  Entity-to-Entity Collisions =====
if (!game_can_step() || !entity_can_deal_damage())
	exit;

var _entityArr = array_concat(
	instance_place_array(x, y, prtEntity, true),
	collision_rectangle_array(x - 3, chainStartY, x + 3, chainEndY, prtEntity, true, true, true)
);
var _numEntities = array_length(_entityArr);
array_sort(_entityArr, function(_a, _b) /*=>*/ {return _a.collisionPriority < _b.collisionPriority});

var i = 0;
repeat(_numEntities) {
	var _subject = _entityArr[i];
	if (entity_can_attack_target(_subject) && !(_subject.lastHitBy == self && hitTimer == 0))
		entity_entity_collision(contactDamage, _subject, _subject);
	
	i++;
}