guiTemplate.draw(x, y);
weaponSubmenu.render(x + guiPositionWeapons[Vector2.x], y + guiPositionWeapons[Vector2.y]);
optionsSubmenu.render(x + guiPositionOptions[Vector2.x], y + guiPositionOptions[Vector2.y]);
playerSubmenu.render(x + guiPositionPlayer[Vector2.x], y + guiPositionPlayer[Vector2.y]);

draw_reset_text_align();
draw_reset_colour();