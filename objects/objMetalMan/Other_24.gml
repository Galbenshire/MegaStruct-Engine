/// @description Entity Tick
event_inherited();

if (!isFighting)
	exit;

conveyorTimer++;
if (conveyorTimer mod conveyorSwitchInterval == 0) {
    var _gameView = game_view();
    with (instance_create_layer(_gameView.left_edge(), _gameView.top_edge(), LAYER_SECTION_GRID, objGenericEffect)) {
        sprite_index = sprDot;
        image_xscale = GAME_WIDTH;
        image_yscale = GAME_HEIGHT;
        depth -= 1;
        lifeDuration = 2;
    }
    
    var _spriteCount = array_length(conveyorSpriteList);
    for (var i = 0; i < _spriteCount; i++) {
        var _sprite = conveyorSpriteList[i];
        layer_sprite_change(_sprite, (layer_sprite_get_sprite(_sprite) == sprMM2ConveyorLeft) ? sprMM2Conveyor : sprMM2ConveyorLeft);
    }
    
    var _areaCount = array_length(conveyorAreaList);
    for (var i = 0; i < _spriteCount; i++) {
        var _area = conveyorAreaList[i];
        _area.image_xscale *= -1;
        _area.x -= _area.sprite_width;
    }
}