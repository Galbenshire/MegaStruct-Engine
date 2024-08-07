draw_sprite_tiled(sprOptionsBG, 0, 0, bgY);
guiTemplate.draw(x, y);

draw_set_alpha(image_alpha);
draw_set_text_align(fa_center, fa_top);

draw_text(x + guiPositionHeader[Vector2.x], y + guiPositionHeader[Vector2.y], menu.currentSubmenu.header);
menu.currentSubmenu.render(x + guiPositionBody[Vector2.x], y + guiPositionBody[Vector2.y]);

draw_reset_text_align();
draw_reset_colour();
draw_set_alpha(1);