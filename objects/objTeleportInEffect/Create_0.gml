event_inherited();

y = (image_yscale >= 0)
    ? game_view().top_edge(y - bbox_bottom, false)
    : game_view().bottom_edge(bbox_top - y, false);

palette = new ColourPalette([ colourPrimary, colourSecondary, colourOutline ]);
animator = new FrameAnimationPlayer();
yspeed = 8 * sign_nonzero(image_yscale);

target = noone;
targetOffsetX = 0;
targetOffsetY = 0;

isMoving = true;

// == Init Animations
animator.add_animation_single_frame("teleport-idle")
	.add_property("image_index", 0);
animator.add_animation_non_loop("teleport-in", 4, 3)
	.add_property("image_index", [0, 1, 0, 2]);
animator.play("teleport-idle");