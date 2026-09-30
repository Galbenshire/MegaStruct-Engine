// These are base callbacks for `onHandleBlock`
// During an entity-entity collision, if the targeted entity has the `BLOCK` flag in its hitmask set,
// `onHandleBlock` will be called to evaluate if the attack will be blocked.
//
// For the most part, you won't actually need to override this callback,
// since `blockType`, as well as both the `BLOCK` & `TAKE_DAMAGE` hitmask flags,
// will cover most block/reflection interactions.
// Should you need advanced interactions however, this callback is available for you to override.
//
// == Parameters
// damageSource (DamageSource) - this represents the current attack. `blockType` determines the type of block
//


/// @func cbkOnHandleBlock_base(damage_source)
/// @desc Default onHandleBlock callback for all entities
///
/// @param {DamageSource}  damage_source  Details on the attack
function cbkOnHandleBlock_base(_damageSource) {
	if (_damageSource.damage == 0) // Attacks that deal no damage force a block
		_damageSource.blockType = max(BlockType.REFLECT, _damageSource.blockType);
	else if (_damageSource.penetrates) // Penetrating attacks ignore blocks
		_damageSource.blockType = BlockType.NONE;
}