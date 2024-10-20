/// @description Insert description here
event_inherited();

characterSpecs = character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

hasCoiled = false;
weapon = undefined;

// Spritesheet
skinSprite = characterSpecs.spritesheet;
skinImageIndex = characterSpecs.spritesheet_page_to_image_index(PlayerSpritesheetPage.COIL);
skinCellX = 0;
skinCellY = 1;

// Palette
palette = new ColourPalette(array_create(PalettePlayer.sizeof + 16));
palette.set_colours([ $0028D8, $F8F8F8, $000000, $A8D8FC, $000000, $FFFFFF ], 16);

// Animations
animator = new FrameAnimationPlayer();
animator.add_animation("idle", 2, 1 / tailWagSpeed)
	.add_property("skinCellX", [0, 1])
	.add_property("skinCellY", [1]);
animator.add_animation_non_loop("coiled", 1, 8)
	.add_property("skinCellX", [2])
	.add_property("skinCellY", [1]);
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
		_spriteAtlas = player_sprite_atlas(skinSprite),
		_isSupported = _colReplacer.IS_SUPPORTED;
	
	if (_isSupported) {
		_colReplacer.activate();
		_colReplacer.apply_palette(palette);
	}
	
	_spriteAtlas.draw_cell_ext(skinCellX, skinCellY, skinImageIndex, x, y - 16, image_xscale, image_yscale, image_blend, image_alpha);
	
	if (_isSupported)
		_colReplacer.deactivate();
};