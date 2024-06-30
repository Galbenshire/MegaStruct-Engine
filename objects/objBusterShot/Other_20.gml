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
    
    onTick = function(_player) {
		with (_player) {
			if (!inputs.is_pressed(InputActions.SHOOT) || lockpool.is_locked(PlayerAction.SHOOT))
				return;
			
			var _shotData = {
				object: objBusterShot,
				limit: 3,
				cost: 0,
				shootAnimation: 1
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = 5 * image_xscale;
				play_sfx(sfxBuster);
			}
		}
	};
}
