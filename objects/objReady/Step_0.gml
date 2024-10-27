if (is_screen_fading())
    exit;

if (--flashTimer <= 0) {
    visible = !visible;
    flashTimer = 7;
}

if (--countdown <= 0 && !audio_is_playing(whistleSFX)) {
    resume_music();
    instance_destroy();
}