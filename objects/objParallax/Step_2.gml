if (!game_can_step(pauseMask))
    exit;

var _ticks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_ticks) {
    var i = 0;
    repeat(layerCount) {
        var _layer/*:ParallaxLayer*/ = layers[i];
        _layer[@ParallaxLayer.x] += _layer[ParallaxLayer.speedX];
        _layer[@ParallaxLayer.y] += _layer[ParallaxLayer.speedY];
        i++;
    }
}