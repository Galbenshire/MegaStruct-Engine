/// @description Weapon Setup
global.weaponList[WeaponType.BUSTER_BASS] = new Weapon(WeaponType.BUSTER_BASS);
with (global.weaponList[WeaponType.BUSTER_BASS]) {
	object = objBusterShot;
	set_name("Bass Buster");
	set_icon(sprWeaponIcons, 2);
	flags = WeaponFlags.NO_AMMO;
    colours = [ $707070, $3898F8 ];
    
    onTick = function(_player) {
		with (_player) {
			if (!player_shot_input(true))
				return;
			
			if (isShooting)
				shootTimer = max(shootTimer, 2);
			
			var _shotData = {
				object: objBassShot,
				limit: 4,
				cost: 0,
				shootAnimation: 1,
				standstill: true,
				autoShootDelay: 6
			};
			
			if (yDir == -1 && xDir == 0)
				_shotData.shootAnimation = 3;
			else if (yDir == -1 && xDir != 0)
				_shotData.shootAnimation = 4;
			else if (yDir)
				_shotData.shootAnimation = 5;
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				var _shotDir = 180 * (image_xscale < 0);
				if (yDir != 0) {
					_shotDir -= (yDir * 90) * image_xscale;
					if (xDir != 0 || yDir == 1)
						_shotDir += (yDir * 45) * image_xscale;
				}
				
				set_velocity_vector(5, _shotDir, _shot);
				play_sfx(sfxBuster);
			}
		}
	};
	
	// == Weapon Specific ==
	
	__get_aim_data = function(_xDir, _yDir) {
		
	};
}