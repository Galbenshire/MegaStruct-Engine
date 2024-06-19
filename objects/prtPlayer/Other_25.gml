/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

if (inputs.is_pressed(InputActions.SHOOT)) {
    var _params = {
        sprite_index: sprBusterShot,
        pierces: PierceType.NEVER,
        factionLayer: [ Faction.PLAYER_PROJECTILE ],
        factionMask: [ Faction.ENEMY_FULL ]
    };
    with (instance_create_depth(x, y, depth, prtProjectile, _params)) {
        xspeed.value = 5.5 * other.image_xscale;
        lifeState = LifeState.ALIVE;
        onSpawn();
    }
}

skinCellX = 0;
if (isSliding)
	skinCellX = 11;
if (isClimbing)
	skinCellX = 15;