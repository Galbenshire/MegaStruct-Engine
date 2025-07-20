if (is_screen_fading())
    exit;

if (--flashTimer <= 0) {
    visible = !visible;
    flashTimer = 7;
}

if (--countdown <= 0 && (!playProtoWhistle || !audio_is_playing(whistleSFXInst))) {
    if (canMuteMusic)
        resume_music();
    
    signal_bus().emit_signal("readyComplete");
    instance_destroy();
}