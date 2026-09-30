// These are base callbacks for `onBlocked`
// During an entity-entity collision, `onBlocked` will be called on the attacking entity
// if the target was able to successfully cancel the attack (via their onHandleBlock callback).
//
// The most prominent use of this callback is to have player projectiles fly away when deflected
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. `blockType` determines the type of block
//

#region Base Callback

/// @func cbkOnBlocked_base(damage_source)
/// @desc Default onBlocked callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnBlocked_base(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Blocked - {0} (by {1})", object_get_name(object_index), object_get_name(_damageSource.subject.object_index));
}

#endregion

#region Available Presets

/// @func cbkOnBlocked_projectile(damage_source)
/// @desc onBlocked callback for projectiles
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnBlocked_projectile(_damageSource) {
    cbkOnBlocked_base(_damageSource);
    isBlocked = true;
    
    switch (_damageSource.blockType) {
		case BlockType.PROTO_SHIELD: projectile_reflection_proto_shield(_damageSource.subject); break;
		case BlockType.DESTROY: projectile_reflection_destroy(); break;
		case BlockType.REFLECT: projectile_reflection_default(-sign(xspeed.value)); break;
		default: /* It's Nothing */ break;
    }
}

/// @func cbkOnBlocked_projectile_destroy(damage_source)
/// @desc onBlocked callback for projectiles that are destroyed when blocked
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnBlocked_projectile_destroy(_damageSource) {
    cbkOnBlocked_base(_damageSource);
    isBlocked = true;
    projectile_reflection_destroy();
}

#endregion