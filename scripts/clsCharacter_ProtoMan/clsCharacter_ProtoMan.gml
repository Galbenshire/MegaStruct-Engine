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
	
	coilColours[PalettePlayer.primary] = $0028D8;
	coilColours[PalettePlayer.secondary] = $F8F8F8;
	coilColours[PalettePlayer.outline] = $000000;
	coilColours[PalettePlayer.skin] = $A8D8FC;
	coilColours[PalettePlayer.face] = $000000;
	coilColours[PalettePlayer.eyes] = $FFFFFF;
	jetColours = coilColours;
	
	weapons = [
        WeaponType.BUSTER_PROTO,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE,
        WeaponType.RUSH_COIL,
        WeaponType.RUSH_JET
    ];
    
    // Main Player Sprites
	playerSprites[PlayerAnimationType.STANDARD] = sprPlayerSkinBlues_Standard;
    playerSprites[PlayerAnimationType.HURTSTUN] = sprPlayerSkinBlues_HurtStun;
    // Weapons
    playerSprites[PlayerAnimationType.BREAK_DASH] = sprPlayerSkinBlues_BreakDash;
	playerSprites[PlayerAnimationType.SLASH_CLAW] = sprPlayerSkinBlues_SlashClaw;
	playerSprites[PlayerAnimationType.TOP_SPIN] = sprPlayerSkinBlues_TopSpin;
	// Misc.
    playerSprites[PlayerAnimationType.TORNADO_BATTERY] = sprPlayerSkinBlues_TornadoBattery;
    playerSprites[PlayerAnimationType.TURNAROUND] = sprPlayerSkinBlues_Turnaround;
    playerSprites[PlayerAnimationType.WAVE_BIKE] = sprPlayerSkinBlues_WaveBike;
    
    mugshotSprite = sprMugshotProtoMan;
    lifeSprite = sprLifeProtoMan;
    coilSprite = sprRushCoilProtoMan;
	jetSprite = sprRushJetProtoMan;
	
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
	
	// Proto Man uses his other hand to shoot,
	// so his gun offsets are different
	for (var i = 0; i < PlayerStandardAnimationSubType.COUNT; i++) {
		var _baseIndex = i * PLAYER_STANDARD_FRAME_COUNT,
			_idleFrame = _baseIndex + PLAYER_ANIM_FRAME_IDLE,
			_sidestepFrame = _baseIndex + PLAYER_ANIM_FRAME_SIDESTEP,
			_walkFrame = _baseIndex + PLAYER_ANIM_FRAME_WALK,
			_jumpFrame = _baseIndex + PLAYER_ANIM_FRAME_JUMP,
			_fallFrame = _baseIndex + PLAYER_ANIM_FRAME_FALL,
			_slideFrame = _baseIndex + PLAYER_ANIM_FRAME_SLIDE,
			_climbFrame = _baseIndex + PLAYER_ANIM_FRAME_CLIMB;
		
		switch (i) {
			default:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [10, 6]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [10, 6]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [10, 6]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [9, 7]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [9, 7]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [9, 2]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [12, 4]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_UP:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [8, -4]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [8, -4]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [9, -5]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [8, -4]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [8, -4]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [8, 0]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [8, -8]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_UP:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [12, 3]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [11, 1]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [13, -1]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [11, -2]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [11, -2]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [12, 2]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [10, -1]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_DOWN:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [10, 11]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [10, 11]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [11, 11]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [11, 11]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [11, 11]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [13, 9]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [10, 8]);
				break;
		}
	}
	
	#endregion
}