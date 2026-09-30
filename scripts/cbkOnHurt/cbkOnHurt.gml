// These are base callbacks for `onHurt`
// During an entity-entity collision, `onHurt` will be called on the targeted entity
// after the attack has successfully connected, dealing damage to them.
//
// This callback allows you to define behaviours upon receiving damage.
// The most notable example being the white-flash effect enemies receive when damaged.
// This is also how the player gets put into their "Hurt" state.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack.
//

#region Base Callbacks

/// @func cbkOnHurt_base(damage_source)
/// @desc Default onHurt callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHurt_base(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Hurt - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    iFrames = 4;
    play_sfx(_damageSource.hitSFX);
}

#endregion

#region Available Presets

/// @func cbkOnHurt_boss(damage_source)
/// @desc Default onHurt callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHurt_boss(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Hurt - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    iFrames = max(1, iFrameDuration);
    self.update_hud(healthpoints);
    play_sfx(_damageSource.hitSFX);
}

/// @func cbkOnHurt_player(damage_source)
/// @desc Default onHurt callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHurt_player(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Player Hurt by {0}", object_get_name(_damageSource.attacker.object_index));
    
    stateMachine.push_or_restart_state("Hurt");
    hudElement.healthpoints = healthpoints;
}

#endregion