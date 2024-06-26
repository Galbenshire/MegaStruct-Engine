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
}

/// @func cbkOnDeath_prtPlayer(damage_source)
/// @desc Default onDeath callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtPlayer(_damageSource) {
    show_debug_message("Player Death by {0}", object_get_name(_damageSource.attacker.object_index));
    
    stateMachine.change("Death");
}

/// @func cbkOnDeath_prtProjectile(damage_source)
/// @desc Default onDeath callback for pojectiles
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnDeath_prtProjectile(_damage_source) {
    if (DEBUG_ENABLED)
        show_debug_message("Death - {0} (by {1})", object_get_name(object_index), object_get_name(_damage_source.attacker.object_index));
    
    lifeState = LifeState.DEAD_ONSCREEN;
    visible = false;
}
