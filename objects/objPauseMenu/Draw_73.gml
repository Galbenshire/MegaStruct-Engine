for (var i = 0; i < bgSpritesCount; i++) {
    with (bgSprites[i])
        draw_sprite_ext(sprite_index, image_index, other.x + x, other.y + y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

menu.submenus.weapons.render(x + markers.weapons[Vector2.x], y + markers.weapons[Vector2.y]);

draw_reset_text_align();
draw_reset_colour();
