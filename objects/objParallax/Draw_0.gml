var _gameView = game_view(),
    _xView = _gameView.get_x(false),
    _yView = _gameView.get_y(false);

if (_gameView.left_edge(0) > areaRight || _gameView.right_edge(0) < areaLeft)
    exit;
if (_gameView.top_edge(0) > areaBottom || _gameView.bottom_edge(0) < areaTop)
    exit;

draw_set_clipping_region(areaLeft, areaTop, areaWidth - 1, areaHeight - 1);

var s = 0;
repeat(layerCount) {
    var _layer/*:ParallaxLayer*/ = layers[s],
        _x = (-_xView * (_layer[ParallaxLayer.parallaxX] - 1)) + _layer[ParallaxLayer.x],
        _y = (-_yView * (_layer[ParallaxLayer.parallaxY] - 1)) + _layer[ParallaxLayer.y];
    
    if (_layer[ParallaxLayer.wrapX] && _layer[ParallaxLayer.wrapY] && _layer[ParallaxLayer.isWholeSprite]) {
        s++;
        draw_sprite_tiled(_layer[ParallaxLayer.sprite], _layer[ParallaxLayer.index], _x, _y);
        continue;
    }
    
    if (!_layer[ParallaxLayer.wrapX] && !_layer[ParallaxLayer.wrapY]) {
        s++;
        draw_sprite_part(_layer[ParallaxLayer.sprite], _layer[ParallaxLayer.index], _layer[ParallaxLayer.left], _layer[ParallaxLayer.top], _layer[ParallaxLayer.width], _layer[ParallaxLayer.height], _x, _y);
        continue;
    }
    
    if (_layer[ParallaxLayer.wrapX])
        _x = _x - floor_to(_x, _layer[ParallaxLayer.width]) - _layer[ParallaxLayer.width];
    if (_layer[ParallaxLayer.wrapY])
        _y = _y - floor_to(_y, _layer[ParallaxLayer.height]) - _layer[ParallaxLayer.height];
    
    var i = 0;
    repeat(_layer[ParallaxLayer.widthSegments]) {
        var j = 0;
        repeat(_layer[ParallaxLayer.heightSegments]) {
            draw_sprite_part(_layer[ParallaxLayer.sprite], _layer[ParallaxLayer.index], _layer[ParallaxLayer.left], _layer[ParallaxLayer.top], _layer[ParallaxLayer.width], _layer[ParallaxLayer.height], _x + _layer[ParallaxLayer.width] * i, _y + _layer[ParallaxLayer.height] * j);
            j++;
        }
        i++;
    }
    
    s++;
}

draw_reset_clipping_region();

// var i = 0;
// repeat(layerCount) {
//     var _layer:ParallaxLayer = layers[i];
//     draw_sprite(sprEnemyBullet, 0,
//         _layer.x + (-_xView * (_layer.parallaxX - 1)),
//         _layer.y + (-_yView * (_layer.parallaxY - 1)));
    
//     i++;
// }
