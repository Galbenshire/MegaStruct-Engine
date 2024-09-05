event_inherited();

phase = 0;
phaseTimer = 0;

chainStartY = y;
chainEndY = y;
chainLegth = 0;
chainYScale = 0;
chainPieceHeight = sprite_get_height(sprCrusherChain);

// Callbacks
onSpawn = function(_damageSource) {
	cbkOnSpawn_prtEntity();
	phase = 0;
	phaseTimer = 0;
	gravEnabled = false;
};
onGuard = method(id, cbkOnGuard_alwaysReflectOrIgnore);
onDraw = function(_whiteflash) {
	draw_sprite_ext(sprCrusherChain, 0, x, chainEndY, 1, -chainYScale, 0, c_white, 1);
	draw_self();
};