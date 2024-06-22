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
    with (spawn_entity(x, y, depth, prtProjectile, _params)) {
        xspeed.value = 5.5 * other.image_xscale;
    }
}

skinCellX = 0;
skinCellY = 0;
animator.update();

if (animator.flag == "step")
	play_sfx(sfxLand);