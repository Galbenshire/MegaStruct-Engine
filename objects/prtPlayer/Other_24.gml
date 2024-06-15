/// @description Entity Tick
xspeed.value = 1.3 * (keyboard_check(ord("D")) - keyboard_check(ord("A")));

if (ground && keyboard_check_pressed(ord("W")))
    yspeed.value = -5.25;
