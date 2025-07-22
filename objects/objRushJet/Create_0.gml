event_inherited();

characterSpecs ??= character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

sprite_index = characterSpecs.jetSprite;

isActive = false;
weapon = undefined;
jetLock = new PlayerLockPoolSwitch(undefined, PlayerAction.MOVE_GROUND, PlayerAction.TURN_GROUND, PlayerAction.CLIMB, PlayerAction.SLIDE);
animTimer = 0;

// Palette
palette = new ColourPalette(characterSpecs.jetColours);

// Callbacks
onSpawn = function() {
	jetLock.pool = owner.lockpool;
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
			palette.set_output_colours(other.characterSpecs.jetColours);
		}
	}
};
onDraw = method(id, cbkOnDraw_colourReplacer);