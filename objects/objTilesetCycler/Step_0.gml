if (!game_can_step(pauseMask))
    exit;

var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_gameTicks) {
    animTimer++;
    
    if (animTimer >= durations[animIndex]) {
        animTimer -= durations[animIndex];
        animIndex = modf(animIndex + 1, tilesetCount);
        tilemap_tileset(tilemap, tilesets[animIndex]);
    }
}