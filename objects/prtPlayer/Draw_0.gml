if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

if (iFrames < 0 || (iFrames & 3) < 2) {
	if (isHurt && (hitTimer & 7) <= 3)
		draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), image_xscale, image_yscale, 0, c_white, 1);
	else
		onDraw();
}

draw_mm_healthbar(game_view().left_edge(16), game_view().top_edge(8), healthpoints, [ $A8E0FC, c_white, c_black ]);

if (!is_undefined(weapon)) {
	draw_mm_healthbar(game_view().left_edge(8), game_view().top_edge(8), weapon.ammo, [ bodyPalette.outputColours[0], bodyPalette.outputColours[1], c_black ]);
	
	if (weaponIconTimer > 0) {
		iconPalette.activate();
		weapon.draw_icon(x - 8, y - 30 * image_yscale);
		iconPalette.deactivate();
	}
}

x = _x;
y = _y;
