if (tilesetCount <= 0) {
    show_debug_message("No tilesets were specified for objTilesetCycler");
    instance_destroy();
    exit;
}

tilemap_tileset(tilemap, tilesets[animIndex]);
