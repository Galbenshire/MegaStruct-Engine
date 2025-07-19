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

#region Base Callbacks

/// @func cbkOnDeath_prtEntity(damage_source)
/// @desc Default onDeath callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
    entity_item_drop();
    entity_clear_hitboxes();
}

/// @func cbkOnDeath_prtBoss(damage_source)
/// @desc Default onDeath callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtBoss(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
	entity_clear_hitboxes();
	entity_item_drop();
	self.disconnect_hud();
	self.restore_music();
	
	if (doPlayerDeathExplosion) {
		player_death_explosion(x, y, depth);
		play_sfx(sfxDeath);
	}
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
		if (!self.is_action_locked(PlayerAction.SPRITE_CHANGE)) {
			animator.play("fall");
			animator.update();
		}
		
		yspeed.value = ycoll;
		yspeed.update();
		y += yspeed.integer;
    }
    
    stateMachine.change_state("Death");
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
    entity_clear_hitboxes();
}

#endregion