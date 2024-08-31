if (global.paused && !global.switchingSections)
    exit;

var _gameTicks = global.gameTimeScale.integer;
if (_gameTicks <= 0)
    exit;

var i = 0;
repeat(layerCount) {
    var _layer/*:ParallaxLayer*/ = layers[i];
    _layer[@ParallaxLayer.x] += _layer[ParallaxLayer.speedX] * _gameTicks;
    _layer[@ParallaxLayer.y] += _layer[ParallaxLayer.speedY] * _gameTicks;
    i++;
}