/// @description Platform Tick
var _x_dir = keyboard_check(ord("L")) - keyboard_check(ord("J")),
    _y_dir = keyboard_check(ord("K")) - keyboard_check(ord("I"));

if (_x_dir == 0 && _y_dir == 0) {
    xspeed.value = 0;
    yspeed.value = 0;
    exit;
}

var _angle = point_direction(0, 0, _x_dir, _y_dir);
xspeed.value = lengthdir_x(moveSpeed, _angle);
yspeed.value = lengthdir_y(moveSpeed, _angle);
