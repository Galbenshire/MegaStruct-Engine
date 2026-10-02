/// @description On Pickup
event_inherited();

with (collectingPlayer) {
    if (weapon.ammo < FULL_HEALTHBAR && !weapon.has_flag(WeaponFlags.NO_AMMO))
        self.restore_weapon_ammo(other.ammoToRestore, weapon);
}