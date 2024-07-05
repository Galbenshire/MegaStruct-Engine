/// @description Boss Tick
cutterExists = instance_exists(cutterInstance);

event_inherited();

airThrowTimer -= !cutterExists;