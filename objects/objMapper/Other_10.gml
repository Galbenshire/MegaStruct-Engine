/// @description Gather Data
// Section Data
with (objSection) {
    other.xMax = max(other.xMax, right);
    other.yMax = max(other.yMax, bottom);
    
    array_push(other.sectionData, self.id);
    other.sectionDataCount++;
}

mapWidth = xMax - xMin;
mapHeight = yMax - yMin;
mapTileWidth = floor(mapWidth / 16);
mapTileHeight = floor(mapHeight / 16);

if (mapTileWidth <= mapSurfaceWidth) {
    xMax = mapSurfaceWidth - mapTileWidth;
    x = -floor((xMax - xMin) / 2);
} else {
    xMin = mapSurfaceWidth - mapTileWidth;
    xMax = 0;
    x = floor((xMax - xMin) / 2);
}

if (mapTileHeight <= mapSurfaceHeight) {
    yMax = mapSurfaceHeight - mapTileHeight;
    y = -floor((yMax - yMin) / 2);
} else {
    yMin = mapSurfaceHeight - mapTileHeight;
    yMax = 0;
    y = floor((yMax - yMin) / 2);
}

// Checkpoint Data
checkpointData = objSystem.debug.checkpointList;
checkpointDataCount = array_length(checkpointData);