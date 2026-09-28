function Character_Bass() : Character() constructor {
	#region Static Data
	
	static id = CharacterType.BASS;
	
	#endregion
	
	#region Variables
	
	name = "Bass";
	entityObject = objBass;
	
	entityProps.jumpSpeed = 4.89453125;
	entityProps.minJumpThreshold = 1;
	entityProps.minJumpCutoff = 0.5;
	entityProps.maxMidairJumps = 1;
	entityProps.slideBoostEnabled = true;
	
	playerColours[PalettePlayer.primary] = $707070;
	playerColours[PalettePlayer.secondary] = $3898F8;
	playerColours[PalettePlayer.outline] = $000000;
	playerColours[PalettePlayer.skin] = $A8E0F8;
	playerColours[PalettePlayer.face] = $000000;
	playerColours[PalettePlayer.eyes] = $FFFFFF;
	
	coilColours[PalettePlayer.primary] = $F00080;
	coilColours[PalettePlayer.secondary] = $707070;
	coilColours[PalettePlayer.outline] = $000000;
	coilColours[PalettePlayer.skin] = $A0E0F8;
	coilColours[PalettePlayer.face] = $000000;
	coilColours[PalettePlayer.eyes] = $F8F8F8;
    
	weapons = [
        WeaponType.BUSTER_BASS,
        WeaponType.ICE_SLASHER,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER,
        WeaponType.RUSH_COIL,
        WeaponType.RUSH_JET
    ];
    
    // Main Player Sprites
	spriteList[PlayerSpriteType.IDLE] = sprPlayerSkinForte_Idle;
	spriteList[PlayerSpriteType.SIDESTEP] = sprPlayerSkinForte_Sidestep;
	spriteList[PlayerSpriteType.WALK] = sprPlayerSkinForte_Walk;
	spriteList[PlayerSpriteType.JUMP] = sprPlayerSkinForte_Jump;
	spriteList[PlayerSpriteType.FALL] = sprPlayerSkinForte_Jump;
	spriteList[PlayerSpriteType.SLIDE] = sprPlayerSkinForte_Slide;
	spriteList[PlayerSpriteType.CLIMB] = sprPlayerSkinForte_Climb;
	spriteList[PlayerSpriteType.CLIMB_TOP] = sprPlayerSkinForte_ClimbTop;
    // Weapons
    spriteList[PlayerSpriteType.BREAK_DASH] = sprPlayerSkinForte_BreakDash;
	spriteList[PlayerSpriteType.SLASH_CLAW] = sprPlayerSkinForte_SlashClaw;
	spriteList[PlayerSpriteType.TOP_SPIN] = sprPlayerSkinForte_TopSpin;
	// Utilities
	spriteList[PlayerSpriteType.COIL] = sprPlayerSkinForte_Coil;
	spriteList[PlayerSpriteType.JET] = sprPlayerSkinForte_Jet;
	// Misc.
	spriteList[PlayerSpriteType.HURTSTUN] = sprPlayerSkinForte_HurtStun;
    spriteList[PlayerSpriteType.TORNADO_BATTERY] = sprPlayerSkinForte_TornadoBattery;
    spriteList[PlayerSpriteType.TURNAROUND] = sprPlayerSkinForte_Turnaround;
    spriteList[PlayerSpriteType.WAVE_BIKE] = sprPlayerSkinForte_WaveBike;
    // Indirect
	spriteList[PlayerSpriteType.LIFE] = sprPlayerSkinForte_Life;
	spriteList[PlayerSpriteType.MUGSHOT] = sprPlayerSkinForte_Mugshot;
	
	#endregion
	
	#region Functions
	
	static personalize_weapon = function(_weapon) {
		switch (_weapon.id) {
			case WeaponType.RUSH_COIL:
				_weapon.set_name("Treble Coil");
				_weapon.set_icon(sprWeaponIcons, 11);
				_weapon.set_colours([ $707070, $F00080 ]);
				break;
			case WeaponType.RUSH_JET:
				_weapon.set_name("Treble Jet");
				_weapon.set_icon(sprWeaponIcons, 12);
				_weapon.set_colours([ $707070, $F00080 ]);
				break;
		}
	};
	
	#endregion
	
	#region Setup Gun Offsets
	
	// I didn't think I'd need to do this explicitly for Bass,
	// since his sprites are just Mega Man's with extra detail slapped on.
	// Then I remembered he dashes, rather than slides.
	
	self.set_gun_offset(PlayerShootType.SHOOT, PlayerSpriteType.SLIDE, 18, 8);
	self.set_gun_offset(PlayerShootType.THROW, PlayerSpriteType.SLIDE, 18, 8);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.SLIDE, 15, -1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.SLIDE, 18, 0);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.SLIDE, 15, 14);
	
	#endregion
}