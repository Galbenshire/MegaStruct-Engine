if (!instance_exists(player)) {
    instance_destroy();
    exit;
}

alarm[0] = 1;

isDone = false;

playerLock = new PlayerLockPoolSwitch(player.lockpool);
if (stopMovement)
    playerLock.add_actions(PlayerAction.MOVE_FULL);
if (forceStopSliding)
    playerLock.add_actions(PlayerAction.SLIDE);
if (stopShooting)
    playerLock.add_actions(PlayerAction.SHOOT);
playerLock.activate();

if (dispelUtilities)
    signal_bus().emit_signal(SIGNAL_DISPEL_UTILITIES);