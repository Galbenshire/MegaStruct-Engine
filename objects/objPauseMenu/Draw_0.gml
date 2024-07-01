for (var i = 0; i < bgSpritesCount; i++) {
    with (bgSprites[i])
        draw_sprite_ext(sprite_index, image_index, other.x + x, other.y + y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

draw_set_text_align(fa_center, fa_middle);
draw_sprite_ext(sprDot, 0, x, y + 96, 256, 32, 0, c_black, 0.8);
draw_text(x + 128, y + 112, "--PAUSE MENU--\n(WIP)");
draw_reset_text_align();
