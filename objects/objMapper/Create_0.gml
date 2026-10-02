mapSurface = NO_SURFACE;
mapSurfaceRefresh = false;
mapSurfaceUpdater = time_source_create(time_source_global, 0.35, time_source_units_seconds, function() /*=>*/ { mapSurfaceRefresh = true; }, [], -1);
mapSurfaceWidth = 160;
mapSurfaceHeight = 160;
mapSurfaceMargin = 4;

sectionData = [];
sectionDataCount = 0;

checkpointData = [];
checkpointDataCount = 0;
currentCheckpoint = 0;

xMin = 0;
xMax = 0;
yMin = 0;
yMax = 0;

mapWidth = 0;
mapHeight = 0;
mapTileWidth = 0;
mapTileHeight = 0;

timer = 0;

event_user(0);
time_source_start(mapSurfaceUpdater);

print($"Checkpoint Count: {checkpointDataCount}");