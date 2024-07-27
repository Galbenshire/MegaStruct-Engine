/// @description Post Tick
if (mouse_check_button_pressed(mb_left)) {
    isPointCheck = !isPointCheck;
    sprite_index = isPointCheck ? sprDot : sprTestPlatform;
}