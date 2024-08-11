/// @description Weapon Setup
global.weaponList[WeaponType.SEARCH_SNAKE] = new Weapon(WeaponType.SEARCH_SNAKE);
with (global.weaponList[WeaponType.SEARCH_SNAKE]) {
    object = objSearchSnake;
    set_name("Search Snake");
	set_icon(sprWeaponIcons, 5);
	colours = [ $00B800, $F8F8F8 ];
	
	onTick = function(_player) {
		with (_player) {
			if (!player_shot_input())
				return;
			
			var _shotData = {
				object: objSearchSnake,
				limit: 3,
				cost: 0.5,
				shootAnimation: 1,
				autoShootDelay: 10
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				_shot.xspeed.value = 1 * image_xscale;
				_shot.yspeed.value = -3 * image_yscale;
				
				play_sfx(sfxBuster);
			}
		}
	};
};
