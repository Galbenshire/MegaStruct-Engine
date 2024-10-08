global.spriteAtlas_Player.sprite = sprPlayerSkinForte;
draw_sprite_ext(global.spriteAtlas_Player.sprite, cellPage, 56, 32, 0.5, 0.5, 0, c_white, 1);

global.spriteAtlas_Player.draw_cell(cellX, cellY, cellPage, playerX, playerY);
draw_sprite_ext(sprEnemyBullet, 0, playerX + gunX, playerY + gunY, 1, 1, 0, c_white, 0.5);

var _params = [
   cellX, cellY, cellPage,
   gunX, gunY
];
var _str = string_ext(debugString, _params);

draw_debug_boxed_text(_str);
