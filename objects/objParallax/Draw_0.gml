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
    with (layers[s]) {
        var _x = (-_xView * (parallaxX - 1)) + x,
            _y = (-_yView * (parallaxY - 1)) + y;
        
        if (wrapX && wrapY && isWholeSprite) {
            draw_sprite_tiled(sprite, index, _x - offsetX, _y - offsetY);
            continue;
        }
        
        if (!wrapX && !wrapY) {
            draw_sprite_part(sprite, index, left, top, width, height, _x, _y);
            continue;
        }
        
        if (wrapX)
            _x = _x - floor_to(_x, width) - width;
        if (wrapY)
            _y = _y - floor_to(_y, height) - height;
        
        var i = 0;
        repeat(widthSegments) {
            var j = 0;
            repeat(heightSegments) {
                draw_sprite_part(sprite, index, left, top, width, height, _x + width * i, _y + height * j);
                j++;
            }
            i++;
        }
    }
    s++;
}

draw_reset_clipping_region();

// var i = 0;
// repeat(layerCount) {
//     with (layers[i]) {
//         draw_sprite(sprEnemyBullet, 0,
//             x + (-_xView * (parallaxX - 1)),
//             y + (-_yView * (parallaxY - 1)));
//     }
    
//     i++;
// }
