event_inherited();

owner = noone; /// @is {prtEntity}
ground = false; // Projectiles usually have no gravity, so they'll start with no ground

// Additional variables for when a projectile is from a player
playerID = -1;
bulletLimitCost = 1;

// Check for a target right away
// Since projectiles should only be spawned by other entities, this should be fine
if (!is_undefined(reticle))
    reticle.update();

// Callbacks
onDeath = method(id, cbkOnDeath_prtProjectile);
onReflected = method(id, cbkOnReflected_prtProjectile);