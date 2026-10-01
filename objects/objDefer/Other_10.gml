/// @description Main Process
if (!active || !game_can_step(pauseMask))
    exit;

var _gameTicks = bitmask_has_bit(pauseMask, PauseType.TIMESCALE) ? global.gameTimeScale.integer : 1;
repeat(_gameTicks) {
    if (--delay > 0)
        continue;
    
    var _finished = deferredAction(caller);
    if (_finished ?? true) {
        instance_destroy();
        break;
    }
    
    timer++;
}