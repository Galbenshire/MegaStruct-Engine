/// @description Close Door
doorOpener.update();

if (doorOpener.integer > 0) {
    if (image_yscale < startYScale) {
        image_yscale++;
        play_sfx(sfxBossDoor);
    } else {
        isOpen = false;
        solidType = SolidType.SOLID;
    }
}
