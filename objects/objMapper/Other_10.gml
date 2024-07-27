/// @description Gather Data
// Section Data
with (objSection) {
    other.xMax = max(other.xMax, bbox_right);
    other.yMax = max(other.yMax, bbox_bottom);
    
    array_push(other.sectionData, self.id);
    other.sectionDataCount++;
}
xMax = floor(xMax / 16) - mapWidth + mapMargin;
yMax = floor(yMax / 16) - mapHeight + mapMargin;

// Checkpoint Data
checkpointData = objSystem.debug.checkpointList;
checkpointDataCount = array_length(checkpointData);

x = clamp(x, xMin, xMax);
y = clamp(y, yMin, yMax);