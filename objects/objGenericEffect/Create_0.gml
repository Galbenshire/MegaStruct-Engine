// Used for effects that wouldn't need their own object
event_inherited();

if (sprite_index == -1) { // No sprite given? Then perish
	instance_destroy();
	exit;
}

xspeed = new Fractional(); /// @is {Fractional}
yspeed = new Fractional(); /// @is {Fractional}

lifeTimer = 0; /// @is {int}

onStep = is_undefined(onStep) ? undefined : method(id, onStep); /// @is {function<void>?}