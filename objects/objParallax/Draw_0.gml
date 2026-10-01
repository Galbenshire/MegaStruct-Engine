var _gameView = game_view();

var _leftEdge = _gameView.left_edge(0),
    _rightEdge = _gameView.right_edge(0);
if (_leftEdge > areaRight || _rightEdge < areaLeft)
    exit;

var _topEdge = _gameView.top_edge(0),
    _bottomEdge = _gameView.bottom_edge(0);
if (_topEdge > areaBottom || _bottomEdge < areaTop)
    exit;

var _xView = _gameView.get_x(false),
    _yView = _gameView.get_y(false);
    
var _useClipping = (_leftEdge < areaLeft || _rightEdge > areaRight || _topEdge < areaTop || _bottomEdge > areaBottom);
if (_useClipping)
    draw_set_clipping_region(areaLeft, areaTop, areaWidth - 1, areaHeight - 1);

var i = 0; repeat(layerCount) {
    layers[i].draw(_xView, _yView);
    i++;
}

if (_useClipping)
    draw_reset_clipping_region();
