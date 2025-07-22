function Character_Bass() : Character() constructor {
	#region Static Data
	
	static id = CharacterType.BASS;
	
	#endregion
	
	#region Variables
	
	name = "Bass";
	entityObject = objBass;
	
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
	jetColours = coilColours;
    
	weapons = [
        WeaponType.BUSTER_BASS,
        WeaponType.ICE_SLASHER,
        WeaponType.SEARCH_SNAKE,
        WeaponType.SKULL_BARRIER,
        WeaponType.RUSH_COIL,
        WeaponType.RUSH_JET
    ];
    
    // Main Player Sprites
	playerSprites[PlayerAnimationType.STANDARD] = sprPlayerSkinForte_Standard;
    playerSprites[PlayerAnimationType.HURTSTUN] = sprPlayerSkinForte_HurtStun;
    // Weapons
    playerSprites[PlayerAnimationType.BREAK_DASH] = sprPlayerSkinForte_BreakDash;
	playerSprites[PlayerAnimationType.SLASH_CLAW] = sprPlayerSkinForte_SlashClaw;
	playerSprites[PlayerAnimationType.TOP_SPIN] = sprPlayerSkinForte_TopSpin;
	// Misc.
    playerSprites[PlayerAnimationType.TORNADO_BATTERY] = sprPlayerSkinForte_TornadoBattery;
    playerSprites[PlayerAnimationType.TURNAROUND] = sprPlayerSkinForte_Turnaround;
    playerSprites[PlayerAnimationType.WAVE_BIKE] = sprPlayerSkinForte_WaveBike;
    
    mugshotSprite = sprMugshotBass;
    lifeSprite = sprLifeBass;
    coilSprite = sprRushCoilBass;
	jetSprite = sprRushJetBass;
	
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
	for (var i = 0; i < PlayerStandardAnimationSubType.COUNT; i++) {
		var _baseIndex = i * PLAYER_STANDARD_FRAME_COUNT,
			_slideFrame = _baseIndex + PLAYER_ANIM_FRAME_SLIDE;
		
		switch (i) {
			default: array_set_multiple(gunOffsetLookup, _slideFrame, 2, [18, 8]); break;
			case PlayerStandardAnimationSubType.SHOOT_UP: array_set_multiple(gunOffsetLookup, _slideFrame, 2, [15, -1]); break;
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_UP: array_set_multiple(gunOffsetLookup, _slideFrame, 2, [18, 0]); break;
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_DOWN: array_set_multiple(gunOffsetLookup, _slideFrame, 2, [15, 14]); break;
		}
	}
	
	#endregion
}