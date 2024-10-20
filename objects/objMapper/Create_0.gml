mapSurface = NO_SURFACE;
mapSurfaceRefresh = false;
mapSurfaceUpdater = time_source_create(time_source_global, 0.35, time_source_units_seconds, function() /*=>*/ { mapSurfaceRefresh = true; }, [], -1);
mapWidth = 224;
mapHeight = 160;
mapMargin = 4;

sectionData = [];
sectionDataCount = 0;

checkpointData = [];
checkpointDataCount = 0;
currentCheckpoint = 0;

xMin = -mapMargin;
xMax = 0;
yMin = -mapMargin;
yMax = 0;

timer = 0;

event_user(0);
time_source_start(mapSurfaceUpdater);

print($"Checkpoint Count: {checkpointDataCount}");