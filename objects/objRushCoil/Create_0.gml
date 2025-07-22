event_inherited();

characterSpecs ??= character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

sprite_index = characterSpecs.coilSprite;

hasCoiled = false;
weapon = undefined;
animTimer = 0;

// Palette
palette = new ColourPalette(characterSpecs.coilColours);

// Callbacks
onSpawn = function() {
	ground = true;
	entity_check_ground();
};
onDeath = function(_damageSource) {
	cbkOnDeath_prtProjectile(_damageSource);
	
	if (characterSpecs.id == CharacterType.PROTO) {
		instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
	} else {
		with (spawn_entity(x, bbox_bottom, depth, objRushTeleport, { isTeleportingOut: true })) {
			weapon = other.weapon;
			characterSpecs = other.characterSpecs;
			owner = other.owner;
			palette.set_output_colours(other.characterSpecs.coilColours);
		}
	}
};
onDraw = method(id, cbkOnDraw_colourReplacer);