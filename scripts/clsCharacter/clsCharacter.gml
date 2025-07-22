/// @func Character()
/// @desc Represents a character that the player can play as in this engine
function Character() constructor {
	#region Static Data (consistent across all character instances)
	
	// ID corresponding to the CharacterType enum
	static id = -1;
	
	#endregion
	
	#region Variables (might differ on a per-instance basis)
	
	// Name of this character
	name = "";
	
	// The entity object representing this character. When the player spawns into a level, this object will be created for them to control.
	entityObject = prtPlayer;
	
	// A list of weapons this character will have available to them
	weapons = [ WeaponType.BUSTER ]; /// @is {array<int>}
	
	// Palettes pertaining to this character
	playerColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer} Default player palette
	coilColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer} Palette for the sprite used for the (Rush) Coil
	jetColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer} Palette for the sprite used for the (Rush) Jet
	
	// Sprites relating to this character
	mugshotSprite = sprMugshotMegaMan;
	lifeSprite = sprLifeMegaMan; /// @is 1-UP Sprite
	coilSprite = sprRushCoilMegaMan; /// @is sprite for (Rush) Coil
	jetSprite = sprRushJetMegaMan; /// @is sprite for (Rush) Jet
	playerSprites = array_create(PlayerAnimationType.COUNT, sprPlayerSkinRockMan_Standard); /// @is {array<sprite>}
	
	// Relative position of the "gun" at each standard frame
	gunOffsetLookup = array_create(PlayerStandardAnimationSubType.COUNT * PLAYER_STANDARD_FRAME_COUNT, [0, 0]); /// @is {array<Vector2>}
	
	#endregion
	
	#region Functions - Getters
	
	/// -- get_gun_offset_at(index)
	/// Gets the gun offset at the given frame of the player's standard sprite
	///
	/// @param {int}  index  The index to get the gun offset of
	///
	/// @returns {Vector2}  The gun offset
	static get_gun_offset_at = function(_index) {
		return array_at(gunOffsetLookup, _index) ?? gunOffsetLookup[0];
	};
	
	/// -- get_name(uppercase)
	/// Gets the name of this character.
	/// Can choose to have the name converted into uppercase.
	///
	/// @param {bool}  [uppercase]  Whether to return the name in uppercase or not. Defaults to false.
	///
	/// @returns {array<int>}  A copy of this characters's loadout.
	static get_name = function(_upper = false) {
		return _upper ? string_upper(name) : name;
	};
	
	/// -- get_player_colours()
	/// Gets the default colours of the entity representing this character. That is, without any changes by weapons.
	///
	/// @returns {PalettePlayer}  A copy of this characters's colours.
	static get_player_colours = function() {
		return variable_clone(playerColours);
	};
	
	/// -- get_weapons()
	/// Gets this character's associated loadout of weapons. Playing as this character gives you these weapons.
	///
	/// @returns {array<int>}  A copy of this characters's loadout.
	static get_weapons = function() {
		return variable_clone(weapons);
	};
	
	#endregion
	
	#region Functions - Setters
	
	/// -- set_entity_object(object)
	/// Sets the entity object to represent this character
	///
	/// @param {prtPlayer}  object  The entity object
	///
	/// @returns {Character}  A reference to this struct. Useful for method chaining.
	static set_entity_object = function(_obj) {
		assert(_obj == prtPlayer || object_is_ancestor(_obj, prtPlayer), "must be a player object");
		entityObject = _obj;
		return self;
	};
	
	#endregion
	
	#region Functions - Other
	
	/// -- personalize_weapon(weapon)
	/// Takes the give weapon, and applies minor adjustments to it
	/// Use to alter a weapon based on the playable character (e.g. Rush Coil becoming Proto Coil for Proto Man)
	///
	/// @param {Weapon}  weapon  The weapon to personalize
	static personalize_weapon = function(_weapon) {
		//...
	};
	
	#endregion
	
	#region Initialization
	
	// == Setup Player Sprites
	// Main
	playerSprites[PlayerAnimationType.STANDARD] = sprPlayerSkinRockMan_Standard;
	playerSprites[PlayerAnimationType.HURTSTUN] = sprPlayerSkinRockMan_HurtStun;
	playerSprites[PlayerAnimationType.TELEPORT] = sprPlayerSkinRockMan_Teleport;
	// Weapons
	playerSprites[PlayerAnimationType.BREAK_DASH] = sprPlayerSkinRockMan_BreakDash;
	playerSprites[PlayerAnimationType.SLASH_CLAW] = sprPlayerSkinRockMan_SlashClaw;
	playerSprites[PlayerAnimationType.TENGU_BLADE] = sprPlayerSkinRockMan_TenguBlade;
	playerSprites[PlayerAnimationType.TOP_SPIN] = sprPlayerSkinRockMan_TopSpin;
	// Misc.
	playerSprites[PlayerAnimationType.TORNADO_BATTERY] = sprPlayerSkinRockMan_TornadoBattery;
	playerSprites[PlayerAnimationType.TURNAROUND] = sprPlayerSkinRockMan_Turnaround;
	playerSprites[PlayerAnimationType.WAVE_BIKE] = sprPlayerSkinRockMan_WaveBike;
	
	// == Setup Gun Offsets
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
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [17, 4]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [17, 4]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [16, 4]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [13, 3]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [13, 3]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [9, 2]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [13, 2]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_UP:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [5, -5]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [5, -5]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [10, -3]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [6, -5]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [6, -5]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [7, 0]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [5, -7]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_UP:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [15, -2]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [15, -2]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [13, -1]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [12, -2]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [12, -2]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [11, 1]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [12, -4]);
				break;
			
			case PlayerStandardAnimationSubType.SHOOT_DIAGONAL_DOWN:
				array_set_multiple(gunOffsetLookup, _idleFrame, 2, [14, 10]);
				array_set_multiple(gunOffsetLookup, _sidestepFrame, 1, [14, 10]);
				array_set_multiple(gunOffsetLookup, _walkFrame, 4, [11, 13]);
				array_set_multiple(gunOffsetLookup, _jumpFrame, 2, [12, 10]);
				array_set_multiple(gunOffsetLookup, _fallFrame, 2, [12, 10]);
				array_set_multiple(gunOffsetLookup, _slideFrame, 2, [11, 10]);
				array_set_multiple(gunOffsetLookup, _climbFrame, 3, [11, 9]);
				break;
		}
	}
	#endregion
}

/// @func character_create_from_id(id)
/// @desc Generates an instance of a playable character (i.e. a struct with info about that character)
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {Character}  A character instance
function character_create_from_id(_id) {
	switch (_id) {
		case CharacterType.MEGA: return new Character_MegaMan(); break;
		case CharacterType.PROTO: return new Character_ProtoMan(); break;
		case CharacterType.BASS: return new Character_Bass(); break;
	}
	
	return undefined;
}

/// @func character_object_from_id(id)
/// @desc Gets the player object that represents the given character
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {prtPlayer}  Object of the character
function character_object_from_id(_id) {
	var _temp = character_create_from_id(_id),
		_obj = _temp.entityObject;
	delete _temp;
	return _obj;
}
