if (!global.paused)
    exit;

if (!__playedSFX) {
    loop_sfx(sfxEnergyRestore);
    __playedSFX = true;
}

refillRate.update();
if (refillRate.integer < 1 && __firstRefill)
    exit;

var _player = global.player;

for (var i = array_length(refillQueue) - 1; i >= 0; i--) {
    var _refillDone = false,
        _refillItem = refillQueue[i][0];
    
    if (is_undefined(_refillItem)) { // Refilling Health
        var _prevHealth = _player.body.healthpoints;
        _player.change_body_healthpoints(1);
        _player.hudElement.healthpoints = _player.body.healthpoints;
        
        refillQueue[i][1]--;
        _refillDone = (refillQueue[i][1] <= 0 || _player.body.healthpoints == _prevHealth);
    } else { // Refilling Weapon Ammo
        var _prevAmmo = _refillItem.ammo;
        _refillItem.change_ammo(1);
        if (_player.hudElement.weaponID == _refillItem.id)
            _player.hudElement.ammo = _refillItem.ammo;
        
        refillQueue[i][1]--;
        _refillDone = (refillQueue[i][1] <= 0 || _refillItem.ammo == _prevAmmo);
    }
    
    if (_refillDone) {
        array_delete(refillQueue, i, 1);
        refillQueueCount--;
    }
}

__firstRefill = true;

if (refillQueueCount <= 0)
    instance_destroy();
