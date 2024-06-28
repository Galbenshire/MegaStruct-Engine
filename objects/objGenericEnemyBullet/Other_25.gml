/// @description Entity Post Tick
if (!is_undefined(onPostTick))
	onPostTick();

if (deathOnSolids && (xcoll != 0 || ycoll != 0))
    onDeath(new DamageSourceSelf());
if (lifeDuration > 0 && lifeTimer >= lifeDuration)
	onDeath(new DamageSourceSelf());
