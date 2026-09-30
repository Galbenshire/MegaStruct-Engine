/// @description Entity Post Tick
if (deathOnSolids && (xcoll != 0 || ycoll != 0))
    entity_kill_self();
if (lifeDuration > 0 && lifeTimer >= lifeDuration)
	entity_kill_self();
