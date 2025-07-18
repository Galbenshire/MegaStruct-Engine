/// @func GUITemplate(prefab_room)
/// @desc Represents a GUI, constructed from a room
///       A GUI Template consists of two components:
///       - A list of sprites that make up the GUI
///       - A map of "markers": key positions on the GUI
///
/// @param {room}  prefab_room  The room representing the GUI
function GUITemplate(_prefabRoom) constructor {
    #region Constants (in spirit)
    
    /// Layer in the room where the sprites should be
    /// @static
    static LAYER_SPRITES = 0;
    
    /// Layer in the room where the markers should be
    /// @static
    static LAYER_MARKERS = 1;
    
    #endregion
    
    #region Variables
    
    sprites = [];
    spriteCount = 0;
    
    markers = {};
    
    #endregion
    
    #region Functions
    
    static draw = function(_x, _y) {
        var i = 0;
        repeat(spriteCount) {
            with (sprites[i])
                draw_sprite_ext(sprite_index, image_index, _x + x, _y + y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
            i++;
        }
    };
    
    static get_position = function(_name) {
        return markers[$ _name];
    };
    
    #endregion
    
    #region Initialization
    
    var _prefabRoomInfo = room_get_info(_prefabRoom, false, false, true, true, false);
    
    sprites = array_reverse(_prefabRoomInfo.layers[LAYER_MARKERS].elements);
    spriteCount = array_length(sprites);
    
    // Grab all the marker positions
    var _markerList = _prefabRoomInfo.layers[LAYER_SPRITES].elements,
        _markerCount = array_length(_markerList);
    for (var i = 0; i < _markerCount; i++) {
        var _marker = _markerList[i],
            _markerName = string_split(_marker.name, "__")[1];
        struct_set(markers, _markerName, [_marker.x, _marker.y]);
    }
    
    #endregion
}
