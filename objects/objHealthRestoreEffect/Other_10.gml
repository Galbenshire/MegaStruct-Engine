/// @description Restore Weapon Ammo
var _player = __refillItem[RefillQueueItem.player],
    _weapon = __refillItem[RefillQueueItem.target],
    _prevAmmo = _weapon.ammo;

_weapon.change_ammo(1);
with (_player) {
    if (hudElement.weaponID == _weapon.id)
        hudElement.weaponAmmo = _weapon.ammo;
}

__refillItem[RefillQueueItem.amount]--;
__refillDone = (__refillItem[RefillQueueItem.amount] <= 0 || _weapon.ammo == _prevAmmo);