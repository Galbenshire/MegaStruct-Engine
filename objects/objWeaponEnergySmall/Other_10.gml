/// @description On Pickup
__collected = true;

with (__collectPlayer) {
    if (is_undefined(weapon))
        exit;
    if (weapon.has_flag(WeaponFlags.NO_AMMO) || weapon.ammo >= FULL_HEALTHBAR)
        exit;
    
    self.restore_weapon_ammo(other.ammoToRestore, weapon);
}