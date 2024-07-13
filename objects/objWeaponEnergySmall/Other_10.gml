/// @description On Pickup
__collected = true;

with (__collectPlayer) {
    if (is_undefined(weapon))
        break;
    if (weapon.has_flag(WeaponFlags.NO_AMMO))
        break;
    
    weapon.change_ammo(other.ammoToRestore);
    if (playerUser.hudElement.ammoWeapon == weapon.id)
        playerUser.hudElement.ammo = weapon.ammo;
}

play_sfx(sfxEnergyRestore);