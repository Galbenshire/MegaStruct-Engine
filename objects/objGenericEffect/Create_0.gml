// Used for effects that wouldn't need their own object
event_inherited();

nameTag = "";
effectTimer = 0; /// @is {int}

onStep = undefined; /// @is {function<void>?}
onDraw = undefined; /// @is {function<void>?}