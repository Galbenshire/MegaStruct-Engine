if (isStalled) {
	var _gameSpeedInt = global.gameTimeScale.integer;
	global.gameTimeScale.integer = 0;
	event_inherited();
	global.gameTimeScale.integer = _gameSpeedInt;
} else {
	event_inherited();
}