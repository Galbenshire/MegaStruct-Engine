if (!global.paused)
    exit;

if (!__playedSFX) {
    loop_sfx(sfxEnergyRestore);
    __playedSFX = true;
}

refillRate.update();
if (refillRate.integer <= 0)
    exit;

for (var i = array_length(refillQueue) - 1; i >= 0; i--) {
    __refillDone = false;
    __refillItem = refillQueue[i];
    
    if (is_instanceof(__refillItem[RefillQueueItem.target], Weapon))
        event_user(0);
    else if (is_undefined(__refillItem[RefillQueueItem.target])) // Refilling Health
        event_user(1);
    
    if (__refillDone) {
        array_delete(refillQueue, i, 1);
        refillQueueCount--;
    }
}

if (refillQueueCount <= 0)
    instance_destroy();