var _xDir = keyboard_check_pressed(vk_numpad6) - keyboard_check_pressed(vk_numpad4);
if (_xDir != 0)
    cellX = modf(cellX + _xDir, global.spriteAtlas_Player.columns);

var _yDir = keyboard_check_pressed(vk_numpad2) - keyboard_check_pressed(vk_numpad8);
if (_yDir != 0)
    cellY = modf(cellY + _yDir, global.spriteAtlas_Player.rows);

var _sDir = keyboard_check_pressed(vk_numpad3) - keyboard_check_pressed(vk_numpad9);
if (_sDir != 0)
    cellPage = modf(cellPage + _sDir, sprite_get_number(global.spriteAtlas_Player.sprite));

if (global.roomTimer & 1) {
    gunX += keyboard_check(ord("D")) - keyboard_check(ord("A"));
    gunY += keyboard_check(ord("S")) - keyboard_check(ord("W"));
}