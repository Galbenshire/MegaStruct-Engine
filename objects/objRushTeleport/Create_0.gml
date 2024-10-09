event_inherited();

phase = 10 * isTeleportingOut;
canLand = true;
weapon = undefined;
characterID = CharacterType.MEGA;

// Palette
palette = new ColourReplacerPalette([ $0028D8, $F8F8F8, $000000, $A8D8FC, $000000, $FFFFFF ]);

// Animations
animator = new FrameAnimationPlayer();
animator.add_animation_non_loop("teleport-idle", 1, 8)
	.add_property("image_index", [0]);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("image_index", [0, 1, 0, 2]);
animator.add_animation_non_loop("teleport-out", 4, 3)
	.add_property("image_index", [2, 0, 1, 0]);
animator.play(isTeleportingOut ? "teleport-out" : "teleport-idle");

// Callbacks
onDraw = method(id, cbkOnDraw_colourReplacer);

if (isTeleportingOut)
    play_sfx(sfxTeleportOut);