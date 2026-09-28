var _charDir = inputs.is_pressed(InputActions.WEAPON_SWITCH_RIGHT) - inputs.is_pressed(InputActions.WEAPON_SWITCH_LEFT);
if (_charDir != 0) {
    characterIndex = modf(characterIndex + _charDir, CharacterType.COUNT);
    currentCharacter = characterList[characterIndex];
}

var _spriteDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
if (_spriteDir != 0) {
    var _prevSprite = playerSprite;
    playerSprite = modf(playerSprite + _spriteDir, PlayerSpriteType.COUNT);
    playerImgIndex = 0;
    if (playerSprite >= PlayerSpriteType.COUNT_STANDARD || _prevSprite >= PlayerSpriteType.COUNT_STANDARD)
        playerShootType = PlayerShootType.IDLE;
}

var _frameDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
if (_frameDir != 0) {
    if (inputs.is_held(InputActions.SLIDE)) {
        playerShootType += _frameDir;
        if (playerSprite < PlayerSpriteType.COUNT_STANDARD)
            playerShootType = modf(playerShootType, PlayerShootType.COUNT);
    } else {
        playerImgIndex = modf(playerImgIndex + _frameDir, currentCharacter.get_sprite_frame_count(playerSprite));
    }
}