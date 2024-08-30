// This object will draw a set of sprites at an offset from the position of the foreground.
// This effect is known as "parallax", and can help give off the illusion of depth.

// Most of this code is based off of Megamix parallax code by InUni.

layers = [];
layerCount = 0;

areaWidth = 0;
areaHeight = 0;

// Function - use this to add layers to the parallax
function add_parallax_layer(_sprite, _index, _parallaxX, _parallaxY, _speedX, _speedY, _wrapX, _wrapY, _offsetXAbs = 0, _offsetYAbs = 0, _offsetXRel = 0, _offsetYRel = 0, _left = 0, _top = 0, _width = sprite_get_width(_sprite), _height = sprite_get_height(_sprite)) {
    var _layer = {
        sprite: _sprite,
        index: _index,
        x: _offsetXAbs + (_offsetXRel * _parallaxX),
        y: _offsetYAbs + (_offsetYRel * _parallaxY),
        parallaxX: _parallaxX,
        parallaxY: _parallaxY,
        speedX: _speedX,
        speedY: _speedY,
        wrapX: bool(_wrapX),
        wrapY: bool(_wrapY),
        left: _left,
        top: _top,
        width: _width,
        widthSegments: 1, // calculated later
        height: _height,
        heightSegments: 1, //calculated later
        isWholeSprite: (_width == sprite_get_width(_sprite)) && (_height == sprite_get_height(_sprite)),
        offsetX: sprite_get_xoffset(_sprite),
        offsetY: sprite_get_yoffset(_sprite)
    };
    
    array_push(layers, _layer);
    layerCount++;
    
    return _layer;
}

// Function - shift the layers by a specific amount, taking their parallax values into account
function shift_by(_x, _y) {
    var i = 0;
    repeat(layerCount) {
        with (layers[i]) {
            x += (_x * parallaxX);
            y += (_y * parallaxY);
        }
        i++;
    }
}