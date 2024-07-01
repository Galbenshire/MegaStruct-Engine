/// @description Weapon Setup
global.weaponList[WeaponType.ICE_SLASHER] = new Weapon(WeaponType.ICE_SLASHER);
with (global.weaponList[WeaponType.ICE_SLASHER]) {
    object = objIceSlasher;
    set_name("Ice Slasher");
	set_icon(sprWeaponIcons, 3);
	colours = [ $F85800, $F8F8F8 ];
	
	onTick = function(_player) {
		with (_player) {
			if (!inputs.is_pressed(InputActions.SHOOT) || lockpool.is_locked(PlayerAction.SHOOT))
				return;
			
			var _shotData = {
				object: objIceSlasher,
				limit: 2,
				cost: 1,
				shootAnimation: 1
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = 5 * image_xscale;
				play_sfx(sfxIceSlasher);
			}
		}
	};
};