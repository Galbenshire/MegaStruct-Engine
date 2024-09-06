/// @description Spawn Item
if (itemDrop == noone || is_undefined(itemDrop))
	exit;

// Spawning an entity
if (object_is_ancestor(itemDrop, prtEntity) || itemDrop == prtEntity) {
	var _item = spawn_entity(x, y, depth, itemDrop);
	_item.x += bbox_x_center() - bbox_x_center(_item);
	_item.y += bbox_y_center() - bbox_y_center(_item);
	_item.respawnType = RespawnType.DISABLED;
	
	if (is_object_type(prtPickup, _item))
		_item.disappearTimer = 270;
	
	if (_item.gravEnabled)
		_item.yspeed.value = -2 * _item.gravDir;
	
	if (!is_undefined(onItemDrop))
		onItemDrop(_item);
	
	exit;
}

// Spawning a non-entity
var _item = instance_create_depth(x, y, depth, itemDrop);
_item.x += bbox_x_center() - bbox_x_center(_item);
_item.y += bbox_y_center() - bbox_y_center(_item);

if (!is_undefined(onItemDrop))
	onItemDrop(_item);
