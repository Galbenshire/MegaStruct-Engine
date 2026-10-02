countdown = 72;
flashTimer = 7;
text = "READY";

pauseLock = new LockStackSwitch(PAUSE_STACK);
pauseLock.activate();

whistleSFXInst = undefined;
if (playProtoWhistle)
    whistleSFXInst = play_sfx(sfxProtoWhistle);

canMuteMusic = playProtoWhistle;
muteDelay = 2 * (global.roomTimer == 0);