/// @description Weapon Setup
global.weaponList[WeaponType.SKULL_BARRIER] = new Weapon(WeaponType.SKULL_BARRIER);
with (global.weaponList[WeaponType.SKULL_BARRIER]) {
    object = objSkullBarrier;
    set_name("Skull Barrier");
	set_icon(sprWeaponIcons, 6);
	colours = [ $FCBC3C, $F0FC9C ];
	
	onTick = function(_player) {
		with (_player) {
			if (!player_shot_input(false))
				return;
			
			var _shotData = {
				object: objSkullBarrier,
				limit: 1,
				cost: 2,
				shootAnimation: 0
			};
			
			var _shot = player_fire_weapon(_shotData);
			with (_shot) {
                x = sprite_x_center(other);
                y = sprite_y_center(other);
                image_xscale = 1;
                image_yscale = 1;
				play_sfx(sfxBuster);
			}
		}
	};
};