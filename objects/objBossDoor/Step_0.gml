/// @description Check if the player is bumping into this door
if (global.paused || global.gameTimeScale.integer <= 0 || !__isInsideView)
    exit;

if (!__canOpen)
    exit;

var _player = collision_rectangle(boundsLeft, boundsTop, boundRight, boundBottom, prtPlayer, false, false);
if (!instance_exists(_player) || _player.isIntro)
    exit;

var i = 0;
repeat(transitionCount) {
    var _transition = transitions[i];
    
    if (!instance_exists(transitions[i])) {
        i++;
        continue;
    }
    
    var _switch = instance_create_depth(_player.x, _player.y, _player.depth, objSectionSwitcher);
	_switch.playerInstance = _player.id;
	_switch.transitionInstance = _transition;
	_switch.bossDoor = id;
	break;
}