// Used for effects that wouldn't need their own object
event_inherited();

xspeed = new Fractional(); /// @is {Fractional}
yspeed = new Fractional(); /// @is {Fractional}

lifeTimer = 0; /// @is {int}

onStep = undefined; /// @is {function<void>?}