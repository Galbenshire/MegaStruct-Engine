function Weapon_BassBuster() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.BUSTER_BASS;
	static colours = [ $707070, $3898F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	static flags = WeaponFlags.NO_AMMO;
	
	// - Icon
	static icon = sprWeaponIcons;
	static iconIndex = 2;
	
	// - Name
	static name = "Bass Buster";
	static shortName = "B.Buster";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		with (_player) {
			if (!self.check_input_shoot(true))
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
			
			var _shot = self.fire_weapon(_shotData);
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
