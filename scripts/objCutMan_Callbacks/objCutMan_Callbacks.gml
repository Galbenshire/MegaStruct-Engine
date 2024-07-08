/// @func cbkOnSetDamage_objCutMan(damage_source)
/// @desc objCutMan onHurt callback
///
/// @param {DamageSource}  damage_source
function cbkOnSetDamage_objCutMan(_damageSource) {
    cbkOnSetDamage_prtBoss(_damageSource);
    
    if (_damageSource.attacker.object_index == objBusterShot)
        _damageSource.set_damage(3);
    if (_damageSource.attacker.object_index == objBusterShotHalfCharge)
        _damageSource.set_damage(3);
    if (_damageSource.attacker.object_index == objBusterShotCharged)
        _damageSource.set_damage(4);
}

/// @func cbkOnHurt_objCutMan(damage_source)
/// @desc objCutMan onHurt callback
///
/// @param {DamageSource}  damage_source
function cbkOnHurt_objCutMan(_damageSource) {
    cbkOnHurt_prtBoss(_damageSource);
    stateMachine.change("Hurt");
}

/// @func cbkOnDeath_objCutMan(damage_source)
/// @desc objCutMan onDeath callback
///
/// @param {DamageSource}  damage_source
function cbkOnDeath_objCutMan(_damageSource) {
    cbkOnDeath_prtBoss(_damageSource);
    
    with (objCutManCutter)
        instance_destroy();
}
