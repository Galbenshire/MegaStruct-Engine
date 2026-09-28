function Character_ProtoMan() : Character() constructor {
	#region Static Data
	
	static id = CharacterType.PROTO;
	
	#endregion
	
	#region Variables
	
	name = "Proto Man";
	entityObject = objProtoMan;
	
	playerColours[PalettePlayer.primary] = $0028DC;
	playerColours[PalettePlayer.secondary] = $BCBCBC;
	playerColours[PalettePlayer.outline] = $000000;
	playerColours[PalettePlayer.skin] = $A5E7FF;
	playerColours[PalettePlayer.face] = $000000;
	playerColours[PalettePlayer.eyes] = $FFFFFF;
	
	weapons = [
        WeaponType.BUSTER_PROTO,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE,
        WeaponType.RUSH_COIL,
        WeaponType.RUSH_JET
    ];
    
    // Main Player Sprites
	spriteList[PlayerSpriteType.IDLE] = sprPlayerSkinBlues_Idle;
	spriteList[PlayerSpriteType.SIDESTEP] = sprPlayerSkinBlues_Sidestep;
	spriteList[PlayerSpriteType.WALK] = sprPlayerSkinBlues_Walk;
	spriteList[PlayerSpriteType.JUMP] = sprPlayerSkinBlues_Jump;
	spriteList[PlayerSpriteType.FALL] = sprPlayerSkinBlues_Jump;
	spriteList[PlayerSpriteType.SLIDE] = sprPlayerSkinBlues_Slide;
	spriteList[PlayerSpriteType.CLIMB] = sprPlayerSkinBlues_Climb;
	spriteList[PlayerSpriteType.CLIMB_TOP] = sprPlayerSkinBlues_ClimbTop;
    // Weapons
    spriteList[PlayerSpriteType.BREAK_DASH] = sprPlayerSkinBlues_BreakDash;
	spriteList[PlayerSpriteType.SLASH_CLAW] = sprPlayerSkinBlues_SlashClaw;
	spriteList[PlayerSpriteType.TOP_SPIN] = sprPlayerSkinBlues_TopSpin;
	// Utilities
	spriteList[PlayerSpriteType.COIL] = sprPlayerSkinBlues_Coil;
	spriteList[PlayerSpriteType.JET] = sprPlayerSkinBlues_Jet;
	// Misc.
	spriteList[PlayerSpriteType.HURTSTUN] = sprPlayerSkinBlues_HurtStun;
    spriteList[PlayerSpriteType.TORNADO_BATTERY] = sprPlayerSkinBlues_TornadoBattery;
    spriteList[PlayerSpriteType.TURNAROUND] = sprPlayerSkinBlues_Turnaround;
    spriteList[PlayerSpriteType.WAVE_BIKE] = sprPlayerSkinBlues_WaveBike;
    // Indirect
	spriteList[PlayerSpriteType.LIFE] = sprPlayerSkinBlues_Life;
	spriteList[PlayerSpriteType.MUGSHOT] = sprPlayerSkinBlues_Mugshot;
	
	#endregion
	
	#region Functions
	
	static personalize_weapon = function(_weapon) {
		switch (_weapon.id) {
			case WeaponType.RUSH_COIL:
				_weapon.set_name("Proto Coil");
				_weapon.set_icon(sprWeaponIcons, 9);
				break;
			case WeaponType.RUSH_JET:
				_weapon.set_name("Proto Jet");
				_weapon.set_icon(sprWeaponIcons, 10);
				break;
		}
	};
	
	#endregion
	
	#region Setup Gun Offsets
	
	// Since Proto Man uses his other arm to shoot, his gun offsets end up different
	
	// Shooting
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.IDLE, 10, 6);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.SIDESTEP, 10, 6);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.WALK, 10, 6);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.JUMP, 9, 7);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.FALL, 9, 7);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.SLIDE, 9, 2);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.CLIMB, 12, 4);
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.CLIMB_TOP, 12, 4);
	// Shooting Up
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.IDLE, 8, -4);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.SIDESTEP, 8, -4);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.WALK, 9, -5);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.JUMP, 8, -4);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.FALL, 8, -4);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.SLIDE, 8, 0);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.CLIMB, 8, -8);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.CLIMB_TOP, 8, -8);
	// Shooting Diagonal Up
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.IDLE, 12, 3);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.SIDESTEP, 11, 1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.WALK, 13, -1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.JUMP, 11, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.FALL, 11, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.SLIDE, 12, 2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.CLIMB, 10, -1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.CLIMB_TOP, 10, -1);
	// Shooting Diagonal Down
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.IDLE, 10, 11);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.SIDESTEP, 10, 11);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.WALK, 11, 11);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.JUMP, 11, 11);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.FALL, 11, 11);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.SLIDE, 13, 9);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.CLIMB, 10, 8);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.CLIMB_TOP, 10, 8);
	
	#endregion
}