/// @description Tick
xspeed = keyboard_check(vk_numpad6) - keyboard_check(vk_numpad4);
yspeed = keyboard_check(vk_numpad2) - keyboard_check(vk_numpad8);

image_xscale += keyboard_check_pressed(vk_numpad9) - keyboard_check_pressed(vk_numpad7);
