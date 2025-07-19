// Performs the "game pauses while player health/ammo gets refilled" effect

refillRate = new Fractional(0.333);
refillRate.fractional = 0.999;
refillQueue = []; /// @is {array<RefillQueueItem>}
refillQueueCount = 0;

__playedSFX = false;
__refillItem = array_create(RefillQueueItem.sizeof); /// @is {RefillQueueItem}
__refillDone = false;

queue_pause();

// Function - call this to queue up a health refill for the player
function queue_health_refill(_player, _amount) {
    // Check if a health refill was already queued, and increase the refill if so
    for (var i = 0; i < refillQueueCount; i++) {
        __refillItem = refillQueue[i];
        
        if (__refillItem[RefillQueueItem.player] == _player && is_undefined(__refillItem[RefillQueueItem.target])) {
            __refillItem[RefillQueueItem.amount] += _amount;
            return;
        }
    }
    
    // If nothing was found, then push up this refill
    array_push(refillQueue, [_player, undefined, _amount]);
    refillQueueCount++;
}

// Function - call this to queue up a weapon refill for the player
function queue_ammo_refill(_player, _weapon, _amount) {
    // Validation
    if (!is_instanceof(_weapon, Weapon))
        return;
    
    // Check if an ammo refill for this chip/weapon was already queued, and increase the refill if so
    for (var i = 0; i < refillQueueCount; i++) {
        __refillItem = refillQueue[i];
        
        if (__refillItem[RefillQueueItem.player] == _player && __refillItem[RefillQueueItem.target] == _weapon) {
            __refillItem[RefillQueueItem.amount] += _amount;
            return;
        }
    }
    
    // If nothing was found, then push up this refill
    array_push(refillQueue, [_player, _weapon, _amount]);
    refillQueueCount++;
}