draw_sprite_tiled(sprOptionsBG, 0, 0, bgY);

for (var i = 0; i < bgSpritesCount; i++) {
    with (bgSprites[i])
        draw_sprite_ext(sprite_index, image_index, other.x + x, other.y + y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

draw_set_alpha(image_alpha);
draw_set_text_align(fa_center, fa_top);

draw_text(x + markers.header[Vector2.x], y + markers.header[Vector2.y], menu.currentSubmenu.header);
menu.currentSubmenu.render(x + markers.body[Vector2.x], y + markers.body[Vector2.y]);

draw_reset_text_align();
draw_reset_colour();
draw_set_alpha(1);