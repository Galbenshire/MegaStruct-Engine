blockerLayer = layer_get_id("Tilemap_Blocker");
blockerTop = layer_get_id("BlockerTop");

onEncounterEnd = function() {
	layer_set_visible(blockerLayer, false);
	layer_set_visible(blockerTop, false);
	play_sfx(sfxExplosionMM3);
	
	repeat(16) {
		var _expl = instance_create_depth(xstart + irandom_range(-32, 32), ystart + 8 + irandom(64), depth, objExplosion);
		_expl.animSpeed = 1 / random_range(2, 4);
	}
};