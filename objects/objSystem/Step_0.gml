if (mouse_check_button_pressed(mb_middle) && !is_debug_overlay_open() && global.roomIsLevel) {
	var _mole = spawn_entity(mouse_x, mouse_y, LAYER_ENTITY, objMole, { image_yscale: sign_nonzero(game_view().center_y() - mouse_y) });
	_mole.respawn = false;
}