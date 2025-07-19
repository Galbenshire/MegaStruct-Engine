/// @description Restore Health
var _player = __refillItem[RefillQueueItem.player],
    _prevHealth = _player.healthpoints;

with (_player) {
    healthpoints = approach(healthpoints, healthpointsStart, 1);
    hudElement.healthpoints = healthpoints;
}

__refillItem[RefillQueueItem.amount]--;
__refillDone = (__refillItem[RefillQueueItem.amount] <= 0 || _player.healthpoints == _prevHealth);
