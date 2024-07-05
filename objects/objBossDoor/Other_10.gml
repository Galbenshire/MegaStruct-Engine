/// @description Open Door
doorOpener.update();

if (doorOpener.integer > 0) {
    if (image_yscale > 0) {
        image_yscale--;
        play_sfx(sfxBossDoor);
    } else {
        isOpen = true;
        solidType = SolidType.NOT_SOLID;
    }
}