draw_rectangle_solid(0, playerY + 32, GAME_WIDTH, 128, c_purple, 1);
draw_rectangle_solid(playerX - 16, 0, 2, GAME_HEIGHT, c_purple, 1);
draw_rectangle_solid(playerX + 14, 0, 2, GAME_HEIGHT, c_purple, 1);

var _str = $"Character: {currentCharacter.name}"
    + $"\nSprite: {playerSprite} ({spriteNames[playerSprite]})"
    + $"\nImage Index: {playerImgIndex}";
if (playerSprite < PlayerSpriteType.COUNT_STANDARD)
    _str += $"\nShoot Type: {playerShootType} ({shootTypeNames[playerShootType]})";
else
    _str += $"\nOffset: {playerShootType}";
draw_text(4, 4, _str);

var _canUseShader = playerSprite != PlayerSpriteType.MUGSHOT;
if (_canUseShader) {
    colour_replacer().activate(ColourReplacerMode.GREYSCALE)
        .apply_output_colours(currentCharacter.playerColours)
        .update_uniforms();
}

var _playerSprite = currentCharacter.get_sprite(playerSprite),
    _spriteCount = currentCharacter.get_sprite_frame_count(playerSprite),
    _imgIndex = playerImgIndex + _spriteCount * playerShootType;
    
draw_sprite_ext(_playerSprite, _imgIndex, playerX, playerY, 2, 2, 0, c_white, 1);

var _previewDrawX = previewX + sprite_get_xoffset(_playerSprite) * 0.5,
    _previewDrawY = previewY + (sprite_get_yoffset(_playerSprite) - sprite_get_height(_playerSprite)) * 0.5,
    _highlightStart = _spriteCount * playerShootType,
    _highlightEnd = _highlightStart + _spriteCount,
    _spriteTrueCount = sprite_get_number(_playerSprite);
    
for (var i = 0; i < _spriteTrueCount; i++) {
    draw_sprite_ext(_playerSprite, i, _previewDrawX, _previewDrawY, 0.5, 0.5, 0, c_white, 1 - 0.5 * !in_range(i, _highlightStart, _highlightEnd));
    _previewDrawX += sprite_get_width(_playerSprite) * 0.5;
}

if (_canUseShader)
    colour_replacer().deactivate();

draw_line_colour(playerX - 3, playerY - 1, playerX + 1, playerY - 1, c_red, c_red);
draw_line_colour(playerX - 1, playerY - 3, playerX - 1, playerY + 1, c_green, c_green);

var _offsetX = (mouse_x - playerX) / 2,
    _offsetY = (mouse_y - playerY) / 2;
draw_text_transformed(mouse_x, mouse_y - 4, $"({_offsetX}, {_offsetY})", 0.5, 0.5, 0);
