/// @description Tick
switch (phase) {
    // === TELEPORT IN ===
    
    case 0: // Moving down from the edge of the screen
        yspeed.value = teleportSpeed * image_yscale;
        
        if (teleportObject == objRushJet && instance_exists(owner))
			ystart = owner.y;
        
        if (canLand && y >= ystart) {
            if (check_for_solids(x, y)) {
                canLand = false;
                despawnRange = 64;
            } else {
                collideWithSolids = true;
            }
        }
        break;
    
    case 1: // End teleport animation
        if (animator.is_animation_finished()) {
            with (instance_create_depth(x, y, depth, teleportObject, { characterSpecs: characterSpecs })) {
                image_xscale = other.image_xscale;
                image_yscale = other.image_yscale;
                gravDir = sign(image_yscale);
                weapon = other.weapon;
                owner = other.owner;
                lifeState = LifeState.ALIVE;
                onSpawn();
            }
            entity_kill_self();
        }
        break;
    
    // === TELEPORT OUT ===
    
    case 10:
        if (animator.is_animation_finished()) {
            yspeed.value = -teleportSpeed * image_yscale;
            despawnRange = 1;
            phase = -99;
        }
        break;
}