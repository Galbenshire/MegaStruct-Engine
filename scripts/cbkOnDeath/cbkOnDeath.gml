// These are base callbacks for `onDeath`
// During an entity-entity collision, `onDeath` will be called on the targeted entity
// if the attack has left them at 0 HP (or below).
//
// This callback is how entities explode on death, which usually leads to an item drop.
// It can also be used to define other behaviours, such as releasing a bullet on death.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

/// @func cbkOnDeath_prtEntity(damage_source)
/// @desc Default onDeath callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
    instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
    entity_clear_hitboxes();
}

/// @func cbkOnDeath_prtPlayer(damage_source)
/// @desc Default onDeath callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtPlayer(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Player Death by {0}", object_get_name(_damageSource.attacker.object_index));
    
    // If the player is about to fall onto a spike,
    // make sure it looks like they're actually hitting it
    if (ground && ycoll * gravDir > 0 && is_object_type(objDamageZone, _damageSource.attacker)) {
		if (!player_is_action_locked(PlayerAction.SPRITE_CHANGE)) {
			animator.play("fall");
			animator.update();
		}
		
		yspeed.value = ycoll;
		yspeed.update();
		y += yspeed.integer;
    }
    
    stateMachine.change("Death");
}

/// @func cbkOnDeath_prtBoss(damage_source)
/// @desc Default onDeath callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtBoss(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
    play_sfx(sfxDeath);
    
	var _explosion_params = {
		sprite_index: sprExplosion,
		animSpeed: 1/3,
		lifeDuration: 0
	};
	for (var i = 0; i < 16; i++) {
		with (instance_create_depth(x, y, depth, objGenericEffect, _explosion_params))
			set_velocity_vector(0.75 * (1 + floor(i / 8)), i * 45);
	}
	
	entity_clear_hitboxes();
}

/// @func cbkOnDeath_prtProjectile(damage_source)
/// @desc Default onDeath callback for projectiles
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtProjectile(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
    visible = false;
}
