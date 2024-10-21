/// @description Draw Surface Contents
surface_set_target(mapSurface);

draw_clear_alpha(c_gray, 0.5);

for (var i = 0; i < sectionDataCount; i++) {
    with (sectionData[i]) {
        var _x = floor(x / 16) - other.x,
            _y = floor(y / 16) - other.y,
            _width = floor(sprite_width / 16),
            _height = floor(sprite_height / 16);
        draw_sprite_stretched_ext(sprMapperSection, 0, _x, _y, _width, _height, image_blend, 1);
    }
}

for (var i = 0; i < checkpointDataCount; i++) {
    var _checkpoint = checkpointData[i],
        _x = (_checkpoint[CheckpointData.x] / 16) - other.x,
        _y = (_checkpoint[CheckpointData.y] / 16) - other.y;
    draw_sprite_ext(sprDot, 0, _x - 1, _y - 1, 2, 2, 0, c_red, 1);
    
    if (_checkpoint == checkpointData[currentCheckpoint])
        draw_circle_colour(_x - 1, _y - 1, 4, c_red, c_red, true);
}

if (instance_exists(global.player.body)) {
    with (global.player.body) {
        var _x = (x / 16) - other.x,
            _y = (y / 16) - other.y;
        draw_sprite_ext(sprDot, 0, _x - 2, _y - 2, 4, 4, 0, c_blue, 1);
    }
}

draw_rectangle_width_colour(-1, -1, mapWidth - 1, mapHeight - 1, 2, c_black, c_black, c_black, c_black);

surface_reset_target();

mapSurfaceRefresh = false;