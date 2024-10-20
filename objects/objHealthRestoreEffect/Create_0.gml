// Performs the "game pauses while player health/ammo gets refilled" effect

refillRate = new Fractional(0.333);
refillQueue = []; /// @is {array<tuple<Weapon?, number>>} [Weapon, Amount] (If Weapon is undefined, it restores health instead)
refillQueueCount = 0;

__playedSFX = false;
__firstRefill = false;

queue_pause();

// Function - call this to queue up a weapon refill for the player
function queue_ammo_refill(_weapon, _amount) {
    // Check if an ammo refill for this weapon was already queued, and increase the refill if so
    for (var i = 0; i < refillQueueCount; i++) {
        if (refillQueue[i][0] == _weapon) {
            refillQueue[i][1] += _amount;
            return;
        }
    }
    
    // If nothing was found, then push up this refill
    array_push(refillQueue, [_weapon, _amount]);
    refillQueueCount++;
}

// Function - call this to queue up a health refill for the player
function queue_health_refill(_amount) {
    // Check if a health refill was already queued, and increase the refill if so
    for (var i = 0; i < refillQueueCount; i++) {
        if (is_undefined(refillQueue[i][0])) {
            refillQueue[i][1] += _amount;
            return;
        }
    }
    
    // If nothing was found, then push up this refill
    array_push(refillQueue, [undefined, _amount]);
    refillQueueCount++;
}