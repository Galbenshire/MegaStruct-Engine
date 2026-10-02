/// @description Check if the player is bumping into this door
if (!game_can_step(PauseType.GAMEPLAY) || !inside_view() || !__canOpen)
	exit;

var _player = collision_rectangle(boundsLeft, boundsTop, boundRight, boundBottom, prtPlayer, false, false);
if (_player == noone)
    exit;
if (!player_is_user_controlled(_player) || !player_is_active(_player))
	exit;

var i = 0; repeat(transitionCount) {
    var _transition = transitions[i];
    if (!instance_exists(_transition)) {
        i++;
        continue;
    }
    
    var _switch = instance_create_layer(x, y, LAYER_FADER, objSectionSwitcher);
	_switch.playerInstance = _player.id;
	_switch.transitionInstance = _transition;
	_switch.bossDoor = id;
	break;
}