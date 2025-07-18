if (!game_can_step())
    exit;

repeat (global.gameTimeScale.integer) {
    animTimer++;
    
    if (animTimer >= durations[animIndex]) {
        animTimer -= durations[animIndex];
        animIndex = modf(animIndex + 1, tilesetCount);
        tilemap_tileset(tilemap, tilesets[animIndex]);
    }
}