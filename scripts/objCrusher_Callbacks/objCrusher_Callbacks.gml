// Callback functions for objCrusher

/// @func cbkOnSpawn_objCrusher(damage_source)
/// @desc objCrusher onSpawn callback
function cbkOnSpawn_objCrusher(_damageSource) {
	phase = 0;
	phaseTimer = 0;
	gravEnabled = false;
}

/// @func cbkOnDraw_objCrusher(whiteflash)
/// @desc objCrusher onDraw callback
function cbkOnDraw_objCrusher(_whiteflash) {
	draw_sprite_ext(sprCrusherChain, 0, x, chainEndY, 1, -chainYScale, 0, c_white, 1);
	draw_self();
}
