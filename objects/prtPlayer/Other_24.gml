/// @description Entity Tick
xspeed.value = 1.3 * (keyboard_check(ord("D")) - keyboard_check(ord("A")));

if (ground && keyboard_check_pressed(ord("W")))
    yspeed.value = -5.25;

if (keyboard_check_pressed(ord("E"))) {
    var _params = {
        sprite_index: sprBusterShot,
        pierces: PierceType.NEVER,
        factionLayer: [ Faction.PLAYER_PROJECTILE ],
        factionMask: [ Faction.ENEMY_FULL ]
    };
    with (instance_create_depth(x, y, depth, prtProjectile, _params)) {
        xspeed.value = 5.5;
        lifeState = LifeState.ALIVE;
        onSpawn();
    }
}
