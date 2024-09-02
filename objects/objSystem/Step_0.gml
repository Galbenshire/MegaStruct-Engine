if (global.roomIsLevel && mouse_check_button_pressed(mb_left)) {
	spawn_entity(floor_to(mouse_x, 16), floor_to(mouse_y, 16), LAYER_ENTITY, objSuzy, {
		healthpointsStart: 1,
		respawnType: RespawnType.DISABLED,
		isHorizontal: false
	});
}