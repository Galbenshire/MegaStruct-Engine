event_inherited();

characterSpecs = character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

isActive = false;
weapon = undefined;
jetLock = new PlayerLockPoolSwitch(undefined, PlayerAction.MOVE_GROUND, PlayerAction.TURN_GROUND, PlayerAction.CLIMB, PlayerAction.SLIDE);

// Spritesheet
skinSprite = characterSpecs.spritesheet;
skinImageIndex = characterSpecs.spritesheet_page_to_image_index(PlayerSpritesheetPage.JET);
skinCellX = 0;
skinCellY = 2;

// Palette
palette = new ColourPalette(array_create(PalettePlayer.sizeof + 16));
palette.set_output_colours([ $0028D8, $F8F8F8, $000000, $A8D8FC, $000000, $FFFFFF ], 16);

// Animations
animator = new FrameAnimationPlayer();
animator.add_animation("idle", 2, 1 / animSpeed)
	.add_property("skinCellX", [0, 1])
	.add_property("skinCellY", [2]);
animator.play("idle");

// Callbacks
onDeath = function(_damageSource) {
	cbkOnDeath_prtProjectile(_damageSource);
	
	if (characterSpecs.id == CharacterType.PROTO) {
		instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
	} else {
		with (spawn_entity(x, bbox_bottom, depth, objRushTeleport, { isTeleportingOut: true })) {
			weapon = other.weapon;
			characterID = other.characterID;
			owner = other.owner;
		}
	}
};
onDraw = function(_whiteflash) {
	var _colReplacer = colour_replacer(),
		_paletteMode = palette.colourMode,
		_spriteAtlas = player_sprite_atlas(skinSprite),
		_isSupported = _colReplacer.is_mode_supported(_paletteMode);
	
	if (_isSupported) {
		_colReplacer.activate(_paletteMode)
			.apply_palette(palette)
			.update_uniforms();
	}
	
	_spriteAtlas.draw_cell_ext(skinCellX, skinCellY, skinImageIndex, x, y - 17, image_xscale, image_yscale, image_blend, image_alpha);
	
	if (_isSupported)
		_colReplacer.deactivate();
};