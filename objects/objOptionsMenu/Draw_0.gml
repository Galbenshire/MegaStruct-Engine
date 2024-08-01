// draw_set_text_align(fa_center, fa_middle);
// draw_text(game_view().center_x(), game_view().center_y(), "UI System\nIn Progress");
// draw_reset_text_align();

draw_set_text_align(fa_left, fa_top);

var _submenus = [
    menu.submenus.controls,
    menu.submenus.display
];
for (var i = 0; i < 2; i++) {
    with (_submenus[i]) {
        var _count = array_length(itemList),
            _baseCol = is_focused() ? c_white : c_gray,
            _x = game_view().left_edge(8) + 96 * i,
            _y = game_view().top_edge(8),
            j = 0;
        
        repeat(_count) {
            draw_set_colour(itemList[j].is_focused() && is_focused() ? c_yellow : _baseCol);
            draw_text(_x, _y, itemList[j].label);
            
            _y += 16;
            j++;
        }
    }
}

with (menu.submenus.audio) {
    var _count = array_length(itemList),
        _baseCol = is_focused() ? c_white : c_gray,
        _x = game_view().left_edge(32),
        _y = game_view().bottom_edge(-64),
        i = 0;
    
    repeat(_count) {
        draw_set_colour(itemList[i].is_focused() && is_focused() ? c_yellow : _baseCol);
        draw_text(_x, _y, itemList[i].label);
        
        _x += 32;
        i++;
    }
}

draw_reset_text_align();
draw_reset_colour();
