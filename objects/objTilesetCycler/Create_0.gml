tilemap = layer_tilemap_get_id(tilemapLayer);
tilesets = [];
durations = [];
tilesetCount = 0;
animTimer = 0;
animIndex = 0;

// Function - call this in Creation Code to define the cycler's tilesets
// e.g addTileset(tstMetalManAnimated_0, 8);
function addTileset(_tileset, _duration) {
    array_push(tilesets, _tileset);
    array_push(durations, _duration);
    tilesetCount++;
}