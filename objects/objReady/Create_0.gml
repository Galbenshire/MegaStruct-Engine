countdown = 72;
flashTimer = 7;
text = "READY";

pauseLock = new LockStackSwitch(objSystem.level.pauseStack);
pauseLock.activate();

whistleSFXInst = undefined;
if (playProtoWhistle)
    whistleSFXInst = play_sfx(whistleSFX);

canMuteMusic = playProtoWhistle;
muteDelay = 2 * (global.roomTimer == 0);