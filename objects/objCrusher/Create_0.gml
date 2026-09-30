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
	cbkOnSpawn_base();
	phase = 0;
	phaseTimer = 0;
	gravEnabled = false;
};
onDraw = function() {
	draw_sprite_ext(sprCrusherChain, 0, x, chainEndY, 1, -chainYScale, 0, c_white, 1);
	draw_self();
};