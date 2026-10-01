if (!game_can_step(pauseMask))
    exit;

var _ticks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_ticks) {
    var i = 0; repeat(layerCount) {
        layers[i].update();
        i++;
    }
    timer++;
}