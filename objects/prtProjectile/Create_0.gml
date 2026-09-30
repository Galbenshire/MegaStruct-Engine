event_inherited();

bulletLimitCost = 1; // Used for checking bullet limits for players
isBlocked = false;

ground = false; // Projectiles usually have no gravity, so they'll start with no ground

// Check for a target right away
// Since projectiles should only be spawned by other entities, this should be fine
if (!is_undefined(reticle))
    reticle.update();

// Callbacks
onDeath = method(id, cbkOnDeath_projectile);
onBlocked = method(id, cbkOnBlocked_projectile);