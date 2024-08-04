/// @description Init Other UI Stuff
var _prefabInfo = room_get_info(pfbOptionsMenu, false, false, true, true, false);

bgSprites = array_reverse(_prefabInfo.layers[1].elements);
bgSpritesCount = array_length(bgSprites);

// This is to fix a visual bug when in YYC
for (var i = 0; i < bgSpritesCount; i++)
    bgSprites[i].sprite_index &= 0xFFFFFFFF;

// Grab all the marker positions
var _markerList = _prefabInfo.layers[0].elements,
    _markerCount = array_length(_markerList);
for (var i = 0; i < _markerCount; i++) {
    var _marker = _markerList[i],
        _markerName = string_split(_marker.name, "__")[1];
    struct_set(markers, _markerName, [_marker.x, _marker.y]);
}