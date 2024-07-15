draw_set_text_align(fa_left, fa_top);
draw_text(gameViewRef.left_edge(16), gameViewRef.top_edge(16), string("OPTIONS MENU ({0})", currentSubmenu.name));
draw_set_halign(fa_center);
draw_text(gameViewRef.center_x(), gameViewRef.bottom_edge(-32), "WPN SWITCH KEYS - CHANGE SUBMENU\nSHOOT - EXIT");

array_foreach(currentSubmenu.options, function(_option, _i) {
    draw_set_halign(fa_left);
    draw_set_colour(_i == optionIndex ? c_yellow : c_white);
    draw_text(gameViewRef.left_edge(16), gameViewRef.top_edge(48 + 16 * _i), _option.label);
    
    draw_set_halign(fa_right);
    draw_text(gameViewRef.right_edge(-16), gameViewRef.top_edge(48 + 16 * _i), _option.display);
});

draw_reset_text_align();
draw_reset_colour();
