draw_sprite_stretched(sprite_index, 0, x - 96, y - 40, 192, 80);

draw_set_text_align(fa_center, fa_top);
draw_text(x, y - 24, $"PRESS {isBindingKeyboard ? "KEY" : "BUTTON"} FOR\n{inputNames[inputIndex]}");
draw_text_colour(x, y, errorMessage, $0010A8, $0010A8, $0010A8, $0010A8, 1);
draw_set_halign(fa_left);
draw_text(x - 88, y + 24, $"{inputIndex + 1}/{InputActions.COUNT}");
draw_set_halign(fa_right);
draw_text(x + 88, y + 24, "DEL: SKIP");

draw_reset_text_align();
