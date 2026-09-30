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

/// @func cbkOnDeath_base(damage_source)
/// @desc Default onDeath callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_base(_damageSource) {
    cbkOnDeath_base_no_fx(_damageSource);
    entity_death_explosion(_damageSource.can_drop_item());
}

/// @func cbkOnDeath_base_no_fx(damage_source)
/// @desc Default onDeath callback for all entities, without the explosion & gib effects
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_base_no_fx(_damageSource) {
    if (DEBUG_ENABLED) {
		var _attacker = _damageSource.attacker,
			_attackerName = (_attacker == self) ? "self" : object_get_name(_attacker.object_index);
		show_debug_message("Death - {0} (by {1})", object_get_name(object_index), _attackerName);
    }
    
    lifeState = LifeState.DEAD_ONSCREEN;
    entity_clear_hitboxes();
}

#endregion

#region Available Presets

/// @func cbkOnDeath_boss(damage_source)
/// @desc Default onDeath callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_boss(_damageSource) {
    cbkOnDeath_base_no_fx(_damageSource);
	self.disconnect_hud();
	self.clear_attacks();
	self.restore_music();
	self.death_effect();
	
	if (_damageSource.can_drop_item())
		itemDrop.spawn_item(bbox_x_center(), bbox_y_center(), depth);
}

/// @func cbkOnDeath_player(damage_source)
/// @desc Default onDeath callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_player(_damageSource) {
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

/// @func cbkOnDeath_projectile(damage_source)
/// @desc Default onDeath callback for projectiles
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_projectile(_damageSource) {
    cbkOnDeath_base_no_fx(_damageSource);
    visible = false;
}

#endregion