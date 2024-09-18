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

var _offset = character.get_gun_offset(self);
draw_sprite_ext(sprEnemyBullet, 0, x + _offset[Vector2.x] * image_xscale, y + _offset[Vector2.y] * image_yscale, image_xscale, image_yscale, image_angle, image_blend, image_alpha * 0.5);

x = _x;
y = _y;