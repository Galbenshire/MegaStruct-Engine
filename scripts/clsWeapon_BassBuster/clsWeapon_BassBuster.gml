function Weapon_BassBuster() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.BUSTER_BASS;
	static flags = WeaponFlags.NO_AMMO;
	
	#endregion
	
	#region Variables
	
	// == Base Weapon Variables ==
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 2;
	iconColours = [ $707070, $3898F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Name
	name = "Bass Buster";
	shortName = "B.Buster";
	
	// - Shot Data
	shotData.set_shot_object(objBassShot)
		.set_shot_limit(4, [ objBassShot ])
		.set_shoot_animation(PlayerShootType.SHOOT)
		.set_shoot_standstill(true)
		.set_auto_shoot_delay(6);
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
			if (!self.check_input_shoot(true))
				return;
			
			if (isShooting)
				shootTimer = max(shootTimer, 2);
			
			var _shootAnim = PlayerShootType.SHOOT;
			if (yDir == -1 && xDir == 0)
				_shootAnim = PlayerShootType.SHOOT_UP;
			else if (yDir == -1 && xDir != 0)
				_shootAnim = PlayerShootType.SHOOT_DIAGONAL_UP;
			else if (yDir)
				_shootAnim = PlayerShootType.SHOOT_DIAGONAL_DOWN;
			other.shotData.set_shoot_animation(_shootAnim);
			
			var _shot = self.fire_weapon(other.shotData);
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
	
	#endregion
}
