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

/// @func cbkOnHurt_prtEntity(damage_source)
/// @desc Default onHurt callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHurt_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Hurt - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
    
    iFrames = 4;
    play_sfx(_damageSource.hitSFX);
}

/// @func cbkOnHurt_prtPlayer(damage_source)
/// @desc Default onHurt callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHurt_prtPlayer(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Player Hurt by {0}", object_get_name(_damageSource.attacker.object_index));
    
    var _inASlideHole = isSliding && test_move_y(-slideMaskHeightDelta * gravDir);
    
    stateMachine.change("Hurt");
    
    if (_inASlideHole) {
        isSliding = true;
        mask_index = maskSlideExtended;
        xspeed.value = 0;
        yspeed.value = 0;
    }
    
    iFrames = 60;
    play_sfx(_damageSource.hitSFX);
}
