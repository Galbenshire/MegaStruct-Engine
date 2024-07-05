/// @description Update faction solid status
event_inherited();

if (global.paused || global.gameTimeScale.integer <= 0)
    exit;

__isInsideView = inside_view();
if (!__isInsideView)
    exit;

__canOpen = false;
var i = 0;
repeat(transitionCount) {
    if (instance_exists(transitions[i])) {
        __canOpen = true;
        break;
    }
    i++;
}
__canOpen &= !isLocked;

factionSolidWhitelist = (0xFFFFFFFF & ~Faction.PLAYER) * __canOpen;