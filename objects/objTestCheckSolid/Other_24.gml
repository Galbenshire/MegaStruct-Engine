/// @description Tick
x = floor(mouse_x);
y = floor(mouse_y);

if (isPointCheck)
    image_blend = check_for_solids_point(x, y) ? c_yellow : c_white;
else
    image_blend = check_for_solids(x, y) ? c_blue : c_white;