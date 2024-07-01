draw_set_valign(fa_top);

array_foreach(options, function(_option, _i) {
    draw_set_halign(fa_left);
    draw_set_colour(_i == optionIndex ? c_yellow : c_white);
    draw_text(gameViewRef.left_edge(16), gameViewRef.top_edge(16 * (_i + 1)), _option.label);
    
    if (struct_exists(_option, "display")) {
        draw_set_halign(fa_right);
        draw_text(gameViewRef.right_edge(-16), gameViewRef.top_edge(16 * (_i + 1)), _option.display);
    }
});

draw_reset_text_align();
draw_reset_colour();
