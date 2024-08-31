if (array_empty(layers)) {
    instance_destroy();
    exit;
}

var _section = find_section_at(sprite_x_center(), sprite_y_center());
if (_section != noone) {
    if (areaLeft == USE_SECTION_EDGE)
        areaLeft = _section.left;
    if (areaTop == USE_SECTION_EDGE)
        areaTop = _section.top;
    if (areaRight == USE_SECTION_EDGE)
        areaRight = _section.right;
    if (areaBottom == USE_SECTION_EDGE)
        areaBottom = _section.bottom;
}

areaWidth = areaRight - areaLeft;
areaHeight = areaBottom - areaTop;

if (areaWidth <= 0 || areaHeight <= 0) {
    print_err($"objParallax ({x}, {y}) was initialized with an invalid area ({areaWidth} x {areaHeight}). It has been deleted.");
    instance_destroy();
    exit;
}

var _xAdjust = 0;
switch (alignX) {
    case "Left": _xAdjust = areaLeft; break;
    case "Center": _xAdjust = areaLeft + ((areaWidth - GAME_WIDTH) / 2); break;
    case "Right": _xAdjust = areaRight - GAME_WIDTH; break;
}
var _yAdjust = 0;
switch (alignY) {
    case "Top": _yAdjust = areaTop; break;
    case "Center": _yAdjust = areaTop + ((areaHeight - GAME_HEIGHT) / 2); break;
    case "Bottom": _yAdjust = areaBottom - GAME_HEIGHT; break;
}

for (var i = 0; i < layerCount; i++) {
    var _layer/*:ParallaxLayer*/ = layers[i];
    _layer[@ParallaxLayer.x] += offsetXAbsolute + ((offsetXRelative + _xAdjust) * _layer[ParallaxLayer.parallaxX]);
    _layer[@ParallaxLayer.y] += offsetYAbsolute + ((offsetYRelative + _yAdjust) * _layer[ParallaxLayer.parallaxY]);
    _layer[@ParallaxLayer.widthSegments] = _layer[ParallaxLayer.wrapX] ? ceil(areaWidth / _layer[ParallaxLayer.width]) + 1 : 1;
    _layer[@ParallaxLayer.heightSegments] = _layer[ParallaxLayer.wrapY] ? ceil(areaHeight / _layer[ParallaxLayer.height]) + 1 : 1;
}