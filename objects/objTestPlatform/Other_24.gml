/// @description Platform Tick
var _x_dir = keyboard_check(ord("L")) - keyboard_check(ord("J")),
    _y_dir = keyboard_check(ord("K")) - keyboard_check(ord("I"));

if (_x_dir == 0 && _y_dir == 0) {
    xspeed = 0;
    yspeed = 0;
    exit;
}

var _angle = point_direction(0, 0, _x_dir, _y_dir);
xspeed = lengthdir_x(moveSpeed, _angle);
yspeed = lengthdir_y(moveSpeed, _angle);
