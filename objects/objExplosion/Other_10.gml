/// @description Spawn Item
if (hasDroppedItem || is_undefined(itemDrop))
	exit;
itemDrop.spawn_item(bbox_x_center(), bbox_y_center(), depth);
hasDroppedItem = true;