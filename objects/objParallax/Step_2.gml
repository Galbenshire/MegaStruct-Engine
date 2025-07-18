if (!game_can_step(false, false, global.switchingSections))
    exit;


repeat(global.gameTimeScale.integer) {
    var i = 0;
    repeat(layerCount) {
        var _layer/*:ParallaxLayer*/ = layers[i];
        _layer[@ParallaxLayer.x] += _layer[ParallaxLayer.speedX];
        _layer[@ParallaxLayer.y] += _layer[ParallaxLayer.speedY];
        i++;
    }
}