// This object will draw a set of sprites at an offset from the position of the foreground.
// This effect is known as "parallax", and can help give off the illusion of depth.

// Most of this code is based off of Megamix parallax code by InUni.

layers = [];
layerCount = 0;

areaWidth = 0;
areaHeight = 0;

// Function - use this to add layers to the parallax
function add_parallax_layer(_sprite, _index, _parallaxX, _parallaxY, _speedX, _speedY, _wrapX, _wrapY, _offsetXAbs = 0, _offsetYAbs = 0, _offsetXRel = 0, _offsetYRel = 0, _left = 0, _top = 0, _width = sprite_get_width(_sprite), _height = sprite_get_height(_sprite)) {
    var _layer/*:ParallaxLayer*/ = array_create(ParallaxLayer.sizeof);
    _layer[@ParallaxLayer.sprite] = _sprite;
    _layer[@ParallaxLayer.index] = _index;
    _layer[@ParallaxLayer.x] = _offsetXAbs + (_offsetXRel * _parallaxX);
    _layer[@ParallaxLayer.y] = _offsetYAbs + (_offsetYRel * _parallaxY);
    _layer[@ParallaxLayer.parallaxX] = _parallaxX;
    _layer[@ParallaxLayer.parallaxY] = _parallaxY;
    _layer[@ParallaxLayer.speedX] = _speedX;
    _layer[@ParallaxLayer.speedY] = _speedY;
    _layer[@ParallaxLayer.wrapX] = bool(_wrapX);
    _layer[@ParallaxLayer.wrapY] = bool(_wrapY);
    _layer[@ParallaxLayer.left] = _left;
    _layer[@ParallaxLayer.top] = _top;
    _layer[@ParallaxLayer.width] = _width;
    _layer[@ParallaxLayer.height] = _height;
    _layer[@ParallaxLayer.widthSegments] = 1; // calculated later
    _layer[@ParallaxLayer.heightSegments] = 1; // same here
    _layer[@ParallaxLayer.isWholeSprite] = _left == 0 && _top == 0 && _width == sprite_get_width(_sprite) && _height == sprite_get_height(_sprite);
    
    array_push(layers, _layer);
    layerCount++;
    
    return _layer;
}

// Function - shift the layers by a specific amount, taking their parallax values into account
function shift_by(_x, _y) {
    var i = 0;
    repeat(layerCount) {
        var _layer/*:ParallaxLayer*/ = layers[i];
        _layer[@ParallaxLayer.x] += (_x * _layer[ParallaxLayer.parallaxX]);
        _layer[@ParallaxLayer.y] += (_y * _layer[ParallaxLayer.parallaxY]);
        i++;
    }
}