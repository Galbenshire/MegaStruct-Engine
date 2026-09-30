event_inherited();

boingTimer = 0;
hasReachedEdge = false;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_base();
    boingTimer = 0;
    image_index = 0;
    mask_index = sprite_index;
    
    ground = true;
    entity_check_ground();
};
onAttackEnd = function(_damageSource) {
    boingTimer = 128;
    xspeed = 0;
};
onMovement = function() {
    mask_index = mskSpringHeadSolid;
    entity_handle_external_forces();
    entity_apply_gravity();
    entity_movement_vertical();
	event_user(1);
	entity_handle_water();
	mask_index = sprite_index;
};

// Palette
event_user(0);