/// @description Entity Tick
xspeed.value = 1.3;
xspeed.update();
yspeed.value = 1.3;
yspeed.update();

repeat(xspeed.integer)
    x += keyboard_check(ord("D")) - keyboard_check(ord("A"));
repeat(yspeed.integer)
    y += keyboard_check(ord("S")) - keyboard_check(ord("W"));
