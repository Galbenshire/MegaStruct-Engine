/// @func GUITemplate(prefab_room)
/// @desc Represents a GUI, constructed from a room
///       A GUI Template consists of two components:
///       - A list of sprites that make up the GUI
///       - A map of "markers": key positions on the GUI
///
/// @param {room}  prefab_room  The room representing the GUI
function GUITemplate(_prefabRoom) constructor {
    #region Constants (in spirit)
    
    /// Layer in the room where the markers should be
    /// @static
    static LAYER_MARKERS = 0;
    
    /// First layer in the room where sprites should be
    /// @static
    static LAYER_SPRITE_START = 1;
    
    #endregion
    
    #region Variables
    
    width = 0;
    height = 0;
    
    sprites = [];
    spriteCount = [];
    layerCount = 0;
    
    markers = {};
    
    #endregion
    
    #region Functions
    
    /// @method draw(x, y, layer)
	/// @desc Draws all the sprites that make up a specific layer of this template
	///
	/// @param {number}  x  x-position to draw at
	/// @param {number}  y  y-position to draw at
	/// @param {int}  [layer]  Which layer of the template to use. Defaults to the first layer.
    static draw = function(_x, _y, _layer = 0) {
        var i = 0; repeat(spriteCount[_layer]) {
			var _spr = sprites[_layer][i];
			draw_sprite_ext(_spr.sprite_index, _spr.image_index,
				_spr.x + _x, _spr.y + _y, _spr.image_xscale, _spr.image_yscale,
				_spr.image_angle, _spr.image_blend, _spr.image_alpha);
            i++;
        }
    };
    
    /// @method draw_shadow(x, y, colour, layer)
	/// @desc Draws all the sprites that make up a specific layer of this template in a single colour
	///
	/// @param {number}  x  x-position to draw at
	/// @param {number}  y  y-position to draw at
	/// @param {int}  [colour]  The colour to use
	/// @param {int}  [layer]  Which layer of the template to use. Defaults to the first layer.
    static draw_shadow = function(_x, _y, _col = c_black, _layer = 0) {
		gpu_push_state();
		gpu_set_fog(true, _col, 0, 0);
		self.draw(_x, _y, _layer);
		gpu_pop_state();
    }
    
    /// @method get_marker(name)
	/// @desc Gets the marker by its name
	///
	/// @param {string}  name  The id name of the marker
	///
	/// @returns {struct?}  The marker, or `undefined` if none exists
    static get_marker = function(_name) {
        return markers[$ _name];
    };
    
    /// @method get_marker_height(name)
    /// @desc Gets the height of a given marker
    ///
	/// @param {string}  name  The id name of the marker
	///
	/// @returns {number}  The height
    static get_marker_height = function(_name) {
		return self.has_marker(_name) ? self.get_marker(_name).height : 0;
    };
    
    /// @method get_marker_size(name)
    /// @desc Gets the size of a given marker
    ///
	/// @param {string}  name  The id name of the marker
	///
	/// @returns {Vector2}  The size
    static get_marker_size = function(_name) {
		if (!self.has_marker(_name))
            return [0, 0];
        
        var _marker = self.get_marker(_name);
        return [_marker.width, _marker.height];
    };
    
    /// @method get_marker_width(name)
    /// @desc Gets the width of a given marker
    ///
	/// @param {string}  name  The id name of the marker
	///
	/// @returns {number}  The width
    static get_marker_width = function(_name) {
		return self.has_marker(_name) ? self.get_marker(_name).width : 0;
    };
    
    /// @method get_position(marker)
	/// @desc Gets the position of a given marker
	///
	/// @param {string}  marker  The id name of the marker
	///
	/// @returns {Vector2}  The position
    static get_position = function(_name) {
        if (!self.has_marker(_name))
            return [0, 0];
        
        var _marker = self.get_marker(_name);
        return [_marker.x, _marker.y];
    };
    
    /// @method has_marker(name)
	/// @desc Checks if the template has the given marker
	///
	/// @param {string}  name  The id name of the potential position
	///
	/// @returns {bool}  Whether the marker exists (true) or not (false)
    static has_marker = function(_name) {
        return struct_exists(markers, _name);
    };
    
    #endregion
    
    #region Initialization
    
    var _prefabRoomInfo = room_get_info(_prefabRoom, false, true, true, true, false);
    
    width = _prefabRoomInfo.width;
    height = _prefabRoomInfo.height;
    layerCount = array_length(_prefabRoomInfo.layers) - 1;
    
    // Get sprite graphics
    for (var i = 0; i < layerCount; i++) {
		var _layer = _prefabRoomInfo.layers[LAYER_SPRITE_START + i];
		sprites[i] = array_map(_layer.elements, function(_el, i) {
			return {
				sprite_index: _el.sprite_index,
				image_index: _el.image_index,
				x: _el.x,
				y: _el.y,
				image_xscale: _el.image_xscale,
				image_yscale: _el.image_yscale,
				image_angle: _el.image_angle,
				image_blend: _el.image_blend,
				image_alpha: _el.image_alpha
			};
		});
		spriteCount[i] = array_length(sprites[i]);
		array_reverse_ext(sprites[i]);
    }
    
    // Grab all marker data
    var _markerList = _prefabRoomInfo.instances;
    for (var i = 0, n = array_length(_markerList); i < n; i++) {
		var _marker = _markerList[i];
		with (_marker)
			_marker.pre_creation_code(); // This gets us the name
		
		var _isArea = (asset_get_index(_marker.object_index) == objGUIMarkerArea);
		struct_set(markers, _marker.name, {
			x: _marker.x,
			y: _marker.y,
			width: _isArea ? sprite_get_width(sprSolid) * _marker.xscale : 0,
			height: _isArea ? sprite_get_height(sprSolid) * _marker.yscale : 0
		});
    }
    
    delete _prefabRoomInfo;
    
    #endregion
}
