// These are base callbacks for `onSetDamage`
// During an entity-entity collision, `onSetDamage` will be called on the targeted entity
// to calculate the amount of damage it should receive from the attack.
//
// This allows you to have weapons deal more damage (or less) to specific types of enemies
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. Use `set_damage` to change the strength of the attack
//

/// @func cbkOnSetDamage_prtEntity(damage_source)
/// @desc Default onSetDamage callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_prtEntity(_damageSource) {
    with (_damageSource) {
        var _dmg = other.damageTable.evaluate_damage(attacker, damage);
        set_damage(_dmg);
    }
}

/// @func cbkOnSetDamage_prtPlayer(damage_source)
/// @desc Default onSetDamage callback for players
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_prtPlayer(_damageSource) {
    // Players only receive whole numbers of damage
    // With 1 damage being the minimum cap
    var _dmg = max(1, floor(_damageSource.damage));
    _damageSource.set_damage(_dmg);
}

/// @func cbkOnSetDamage_prtBoss(damage_source)
/// @desc Default onSetDamage callback for bosses
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnSetDamage_prtBoss(_damageSource) {
    _damageSource.set_damage(1); // All attacks deal 1 damage by default
    cbkOnSetDamage_prtEntity(_damageSource); // Weaknesses then get applied
}
