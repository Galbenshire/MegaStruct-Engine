/// @description Entity Tick
if (xcoll != 0 || ycoll != 0)
	entity_kill_self();
else if (check_for_solids(x, y))
	entity_kill_self();