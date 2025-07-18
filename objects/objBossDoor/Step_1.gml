/// @description Update faction solid status
event_inherited();

if (!game_can_step() || !inside_view())
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