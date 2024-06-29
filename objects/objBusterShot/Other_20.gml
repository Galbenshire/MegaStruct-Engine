/// @description Weapon Setup
global.weaponList[WeaponType.BUSTER] = new Weapon();
with (global.weaponList[WeaponType.BUSTER]) {
	id = WeaponType.BUSTER;
	object = objBusterShot;
	set_name("Mega Buster");
	set_icon(sprWeaponIcons, 1);
	flags = WeaponFlags.NO_AMMO | WeaponFlags.CHARGE;
	
	// -- Top: NES
    // -- Bottom: MM9 & 10
    //colours = [ $EC7000, $D8E800 ];
    colours = [ $EC7000, $F8B838 ];
    
}
