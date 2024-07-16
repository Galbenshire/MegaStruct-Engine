if (!global.paused)
    exit;

if (timer == 0) 
    loop_sfx(sfxEnergyRestore);

if (timer mod 3 == 0) {
    var _player = global.player;
    
    if (healthpoints > 0) {
        var _prevHealth = _player.body.healthpoints;
        _player.change_body_healthpoints(1);
        _player.hudElement.healthpoints = _player.body.healthpoints;
        
        if (_player.body.healthpoints == _prevHealth)
            healthpoints = 0;
        else
            healthpoints--;
    }
    
    if (ammoCount > 0) {
        var _count = ammoCount;
        for (var i = _count - 1; i >= 0; i--) {
            var _prevAmmo = ammo[0][i].ammo;
            ammo[0][i].change_ammo(1);
            if (_player.hudElement.ammoWeapon == ammo[0][i].id)
                _player.hudElement.ammo = ammo[0][i].ammo;
            
            if (ammo[0][i].ammo == _prevAmmo)
                ammo[1][i] = 0;
            else
                ammo[1][i]--;
            
            if (ammo[1][i] <= 0) {
                array_delete(ammo[0], i, 1);
                array_delete(ammo[1], i, 1);
                ammoCount--;
            }
        }
    }
}

timer++;

if (healthpoints <= 0 && ammoCount <= 0)
    instance_destroy();
