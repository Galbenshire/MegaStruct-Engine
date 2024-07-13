if (mouse_check_button_pressed(mb_middle) && !is_debug_overlay_open()) {
	var _health = spawn_entity(mouse_x, mouse_y, LAYER_ENTITY, objHealthEnergySmall);
	_health.disappearTimer = 270;
	_health.respawn = false;
}