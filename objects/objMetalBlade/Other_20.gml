/// @description Weapon Setup
global.weaponList[WeaponType.METAL_BLADE] = new Weapon(WeaponType.METAL_BLADE);
with (global.weaponList[WeaponType.METAL_BLADE]) {
    object = objMetalBlade;
    set_name("Metal Blade");
	set_icon(sprWeaponIcons, 3);
	colours = [ $007088, $A8E0FF ];
	
	onTick = function(_player) {
        with (_player) {
            if (!player_shot_input())
				return;
            
            var _shotData = {
				object: objMetalBlade,
				limit: 3,
				cost: 0.5,
				shootAnimation: 2,
				offsetY: 3,
				standstill: true,
				autoShootDelay: 20
			};
			
			var _shot = player_fire_weapon(_shotData);
			if (_shot != noone) {
				var _dir = 180 * (image_xscale < 0);
                
                if (yDir != 0) {
                    _dir -= (yDir * 90) * image_xscale;
                    if (xDir != 0)
                        _dir += (yDir * 45) * image_xscale;
                }
                
                set_velocity_vector(4, _dir, _shot);
				play_sfx(sfxMetalBlade);
			}
        }
	};
};