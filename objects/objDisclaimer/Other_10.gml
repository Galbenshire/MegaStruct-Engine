if (is_screen_fading())
    exit;

var _room = keyboard_check(vk_shift) ? rmPlayerSpritesheetTest : nextRoom;
go_to_room(_room);