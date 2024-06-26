/// @description Main Process
if (!ignorePause && global.paused)
    exit;

var _gameTicks = ignoreTimeScale ? 1 : global.gameTimeScale.integer;

repeat(_gameTicks) {
    if (--delay > 0)
        continue;
    
    deferredAction(caller);
    if (runOnce) {
        instance_destroy();
        break;
    }
}