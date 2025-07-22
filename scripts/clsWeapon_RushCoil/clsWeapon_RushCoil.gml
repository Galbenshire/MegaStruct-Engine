function Weapon_RushCoil() : Weapon() constructor {
    #region Static Data (consistent across all weapon instances)
	
	static id = WeaponType.RUSH_COIL;
	
	#endregion
	
	#region Variables
	
	colours = [ $0028D8, $F8F8F8, $000000, $A8D8FC, $F8F8F8 ]; /// @is {PaletteWeapon}
	
	// - Icon
	icon = sprWeaponIcons;
	iconIndex = 7;
	
	// - Name
	name = "Rush Coil";
	shortName = "R.Coil";
	
	#endregion
	
	#region Callbacks
	
	static on_tick = function(_player) {
		if (self.can_summon_dog(_player)) {
			if (!_player.check_input_shoot(false))
				return;
			
			var _shot = _player.fire_weapon({
				object: objRushTeleport,
				limit: 1,
				cost: 0,
				shootAnimation: PlayerStandardAnimationSubType.IDLE,
				offsetX: 20,
				projParams: {
					teleportObject: objRushCoil
				}
			});
			
			if (_shot != noone) {
				_shot.characterSpecs = _player.characterSpecs;
				_shot.weapon = self;
				_shot.palette.set_output_colours(_shot.characterSpecs.coilColours);
				_shot.y = game_view().center_y(false) - (GAME_HEIGHT / 2) * _player.image_yscale;
			}
		} else {
			if (!_player.check_input_shoot())
				return;
			
			var _shot = _player.fire_weapon({
				object: objBusterShot,
				limit: 4,
				cost: 0,
				shootAnimation: PlayerStandardAnimationSubType.SHOOT,
				autoShootDelay: 8
			});
			
			if (_shot != noone) {
				_shot.xspeed.value = 5 * _player.image_xscale;
				play_sfx(sfxBuster);
			}
		}
	};
	
	#endregion
	
	#region Functions
	
	static can_summon_dog = function(_player) {
		with (objRushCoil) {
			if (owner == _player.id)
				return false;
		}
		with (objRushTeleport) {
			if (owner == _player.id)
				return false;
		}
		return ammo > 0;
	};
	
	#endregion
}
