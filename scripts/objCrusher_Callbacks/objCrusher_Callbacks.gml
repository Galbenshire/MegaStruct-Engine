function cbkOnSpawn_objCrusher(_damageSource) {
	phase = 0;
	phaseTimer = 0;
	gravEnabled = false;
}

function cbkOnGuard_objCrusher(_damageSource) {
	_damageSource.guard = GuardType.REFLECT_OR_IGNORE;
}

function cbkOnDraw_objCrusher(_whiteflash) {
	draw_sprite_ext(sprCrusherChain, 0, x, chainEndY, 1, -chainYScale, 0, c_white, 1);
	draw_self();
}
