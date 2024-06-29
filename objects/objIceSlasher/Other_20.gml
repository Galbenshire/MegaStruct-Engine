/// @description Weapon Setup
global.weaponList[WeaponType.ICE_SLASHER] = new Weapon();
with (global.weaponList[WeaponType.ICE_SLASHER]) {
	id = WeaponType.ICE_SLASHER;
    object = objIceSlasher;
    set_name("Ice Slasher");
	set_icon(sprWeaponIcons, 3);
	colours = [ $F85800, $F8F8F8 ];
};