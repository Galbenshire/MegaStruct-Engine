tilemap = layer_tilemap_get_id(tilemapLayer);
if (tilemap == NOT_FOUND) {
    show_debug_message("No tilemap could be found for objTilesetCycler");
    instance_destroy();
    exit;
}

tilesets = [];
durations = [];
tilesetCount = 0;
animTimer = 0;
animIndex = 0;

// Function - call this in Creation Code to define the cycler's tilesets
// e.g add_tileset(tstMetalManAnimated_0, 8);
function add_tileset(_tileset, _duration) {
    array_push(tilesets, _tileset);
    array_push(durations, _duration);
    tilesetCount++;
}