event_inherited();

lifeTimer = 0; /// @is {int}
palette = undefined; /// @is {ColourReplacer?}

onTick = is_undefined(onTick) ? undefined : method(id, onTick); /// @is {function<void>?}
onPostTick = is_undefined(onPostTick) ? undefined : method(id, onPostTick); /// @is {function<void>?}

// Callbacks
onDeath = function(_damageSource) {
    cbkOnDeath_prtProjectile(_damageSource);
    if (explodeOnDeath)
        instance_create_depth(x, y, depth, objExplosion);
};
onDraw = method(id, cbkOnDraw_colourReplacer);