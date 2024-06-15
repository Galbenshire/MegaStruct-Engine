core.stepBegin();
debug.stepBegin();
input.stepBegin();

if (mouse_check_button_pressed(mb_left))
	screen_shake(infinity, 1, 1);
if (mouse_check_button_pressed(mb_right))
	stop_screen_shake();