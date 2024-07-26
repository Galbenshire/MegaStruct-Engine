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
