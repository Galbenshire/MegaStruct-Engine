// These are base callbacks for `onGuard`
// During an entity-entity collision, `onGuard` will be called on the targeted entity
// to evaluate if it is able to guard against the attack.
// By modifying the `guard` variable in the DamageSource passed in the callback,
// the target is able to specify if the attack will be cancelled.
//
// The available values for `guard` correspond to the GuardType enum, and are as follow:
// - GuardType.DAMAGE: The default value. The attack will continue as normal; the target receiving damage.
// - GuardType.REFLECT: The exact outcome will depend on the attacker's `penetrate` variable:
//      - PenetrateType.NONE: The attack is cancelled. The attacker will be reflected (by calling its `onReflected` callback)
//      - PenetrateType.NO_DAMAGE: The attack is cancelled. The attacker will pass through the target
//      - PenetrateType.NO_DAMAGE_AND_COLLISION: Similar to PenetrateType.NO_DAMAGE,
//          except this also disables any further interactions between attacker & target
//      - PenetrateType.BYPASS_GUARD: The attack is allowed to continue as normal. The target will take damage.
// - GuardType.IGNORE: The attack is cancelled. The attacker will pass through the target.
//      (This is similar to having `canTakeDamage` set to false, except the target will still be targeted by the attacker)
// - GuardType.REFLECT_OR_IGNORE: The attack is cancelled.
//      Reflects the attacker if it's non-penetrating, otherwise, the attacker will pass through the target.
// - GuardType.FORCE_REFLECT: The attack is cancelled.
//      The attacker will always be reflected, regardless of their `penetrate` value.
//
// The most notable use case for this callback would be to have enemies deflect player projectiles.
// An example would be a Sniper Joe, who can shrug off most weapon if their shield is up.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. Change its `guard` value to cancel the attack
//

/// @func _fnsEntity_onGuard(damage_source)
/// @desc Default onGuard callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_prtEntity(_damageSource) {
    if (DEBUG_ENABLED)
        show_debug_message("Guard - {0} (against {1})", object_get_name(object_index), object_get_name(_damageSource.attacker.object_index));
}

// == Callback Presets ==

/// @func cbkOnGuard_alwaysIgnore(damage_source)
/// @desc A simple "ignore all shots" onGuard callback
///       All attacks will be ignored
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_alwaysIgnore(_damageSource) {
    _damageSource.guard = GuardType.IGNORE;
}

/// @func cbkOnGuard_alwaysReflect(damage_source)
/// @desc A simple "reflect all shots" onGuard callback
///       All non-penetrating attacks will be reflected
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_alwaysReflect(_damageSource) {
    _damageSource.guard = GuardType.REFLECT;
}

/// @func cbkOnGuard_alwaysReflectOrIgnore(damage_source)
/// @desc A simple "reflect/ignore all shots" onGuard callback
///       All attacks will be reflected or ignored (depending on the attacker's `penetrate` variable)
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_alwaysReflectOrIgnore(_damageSource) {
    _damageSource.guard = GuardType.REFLECT_OR_IGNORE;
}

/// @func cbkOnGuard_imageIndex(damage_source)
/// @desc A simple "reflect shots" onGuard callback
///       When the entity's image_index is a value other than 0,
///       They will reflect all non-penetrating shots.
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnGuard_imageIndex(_damageSource) {
    if (image_index == 0)
        _damageSource.guard = GuardType.REFLECT;
}
