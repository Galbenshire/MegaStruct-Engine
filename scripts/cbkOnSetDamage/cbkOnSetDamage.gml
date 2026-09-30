// These are base callbacks for `onSetDamage`
// During an entity-entity collision, `onSetDamage` will be called on the targeted entity
// to calculate the amount of damage it should receive from the attack.
//
// This allows you to have weapons deal more damage (or less) to specific types of enemies
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. Use `set_damage` to change the strength of the attack
//

#region Base Callbacks

/// @func cbkOnSetDamage_base(damage_source)
/// @desc Default onSetDamage callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_base(_damageSource) {
    var _dmg = damageTable.evaluate_damage(_damageSource.attacker, _damageSource.damage);
    _damageSource.set_damage(_dmg);
}

#endregion

#region Available Presets

/// @func cbkOnSetDamage_boss(damage_source)
/// @desc Default onSetDamage callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_boss(_damageSource) {
    // If set, all attacks will deal 1 damage by default
    if (defaultDamageIsOne)
        _damageSource.set_damage(1);
    
    cbkOnSetDamage_base(_damageSource); // Weaknesses then get applied
}

/// @func cbkOnSetDamage_player(damage_source)
/// @desc Default onSetDamage callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_player(_damageSource) {
    // Players only receive whole numbers of damage
    // With 1 damage being the minimum cap
    var _dmg = max(1, floor(_damageSource.damage));
    _damageSource.set_damage(_dmg);
}

#endregion