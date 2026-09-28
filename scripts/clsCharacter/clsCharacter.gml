/// === MACROS relating to playable characters ===

enum CharacterType {
	MEGA,
	PROTO,
	BASS,
	
	COUNT
}

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
	
	// A list of the sprites relevant to this character
	// (includes the entity sprites, and other indirect sprites such as the mugshot)
	spriteList = array_create(PlayerSpriteType.COUNT, sprPlayerSkinRockMan_Idle);
	spriteFrameCount = array_create(PlayerSpriteType.COUNT, 1);
	
	// Palettes pertaining to this character
	playerColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer} Default player palette
	coilColours = array_create(PalettePlayer.sizeof); /// @is {PalettePlayer} Palette for the sprite used for the (Rush) Coil
	jetColours = coilColours; /// @is {PalettePlayer} Palette for the sprite used for the (Rush) Jet
	
	// Relative position of the "gun" at each standard animation type
	// Each frame has two indexes; one for the X, another for the Y
	gunOffsetLookupCount = PlayerSpriteType.COUNT_STANDARD * PlayerShootType.COUNT;
	gunOffsetLookup = array_create(gunOffsetLookupCount * 2); /// @is {array<int>}
	
	#endregion
	
	#region Functions - Getters
	
	/// -- get_gun_offset_at(shoot_type, sprite_type)
	/// Gets the gun offset for the given player sprite, taking into account the type of shooting
	///
	/// @param {int}  shoot_type  The type of shooting
	/// @param {int}  sprite_type  The type of player sprite
	///
	/// @returns {Vector2}  The gun offset
	static get_gun_offset_at = function(_shootType, _spriteType) {
		var _index = _spriteType + (PlayerSpriteType.COUNT_STANDARD * _shootType);
		_index *= 2;
		return [ gunOffsetLookup[_index], gunOffsetLookup[_index + 1] ];
	};
	
	/// -- get_image_index(sprite_id, index, offset)
	/// Helper function for getting the image index of a specific sprite
	///
	/// @param {int}  sprite_id  Which sprite is being used (see the `PlayerSpriteType` enum)
	/// @param {int}  index  Which frame of the sprite to get
	/// @param {int}  offset  An offset from the sprite's frame count. Optional.
	///
	/// @returns {int}  The image index
	static get_image_index = function(_spriteID, _index, _offset = 0) {
		return _index + spriteFrameCount[_spriteID] * _offset;
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
	
	/// -- get_sprite(sprite_id)
	/// Gets a specific player sprite, using the index provided
	///
	/// @param {int}  sprite_id  Which sprite to get (see the `PlayerSpriteType` enum)
	///
	/// @returns {sprite}  The specific player sprite
	static get_sprite = function(_spriteID) {
		return spriteList[_spriteID];
	};
	
	/// -- get_sprite_frame_count(sprite_id)
	/// Gets the number of frames present in a specific player sprite
	///
	/// @param {int}  sprite_id  Which sprite to get (see the `PlayerSpriteType` enum)
	///
	/// @returns {int}  The number of frames within the given sprite
	static get_sprite_frame_count = function(_spriteID) {
		return spriteFrameCount[_spriteID];
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
	
	/// -- set_gun_offset(shoot_type, sprite_type, x, y)
	/// Given a player sprite type, and the type of shooting being performed, this fuctions sets the corresponding gun offset
	///
	/// @param {int}  shoot_type  The type of shooting being done
	/// @param {int}  sprite_type  The type of player sprite
	/// @param {int}  x  Horizontal offset
	/// @param {int}  y  Vertical offset
	static set_gun_offset = function(_shootType, _spriteType, _x, _y) {
		var _index = _spriteType + (PlayerSpriteType.COUNT_STANDARD * _shootType);
		if (in_range(_index, 0, gunOffsetLookupCount)) {
			_index *= 2;
			gunOffsetLookup[_index] = _x;
			gunOffsetLookup[_index + 1] = _y;
		}
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
	// Standard
	spriteList[PlayerSpriteType.IDLE] = sprPlayerSkinRockMan_Idle;
	spriteList[PlayerSpriteType.SIDESTEP] = sprPlayerSkinRockMan_Sidestep;
	spriteList[PlayerSpriteType.WALK] = sprPlayerSkinRockMan_Walk;
	spriteList[PlayerSpriteType.JUMP] = sprPlayerSkinRockMan_Jump;
	spriteList[PlayerSpriteType.FALL] = sprPlayerSkinRockMan_Jump;
	spriteList[PlayerSpriteType.SLIDE] = sprPlayerSkinRockMan_Slide;
	spriteList[PlayerSpriteType.CLIMB] = sprPlayerSkinRockMan_Climb;
	spriteList[PlayerSpriteType.CLIMB_TOP] = sprPlayerSkinRockMan_ClimbTop;
	// Weapons
	spriteList[PlayerSpriteType.BREAK_DASH] = sprPlayerSkinRockMan_BreakDash;
	spriteList[PlayerSpriteType.SLASH_CLAW] = sprPlayerSkinRockMan_SlashClaw;
	spriteList[PlayerSpriteType.TENGU_BLADE] = sprPlayerSkinRockMan_TenguBlade;
	spriteList[PlayerSpriteType.TOP_SPIN] = sprPlayerSkinRockMan_TopSpin;
	// Utilities
	spriteList[PlayerSpriteType.COIL] = sprPlayerSkinRockMan_Coil;
	spriteList[PlayerSpriteType.JET] = sprPlayerSkinRockMan_Jet;
	// Misc.
	spriteList[PlayerSpriteType.HURTSTUN] = sprPlayerSkinRockMan_HurtStun;
	spriteList[PlayerSpriteType.TELEPORT] = sprPlayerSkinRockMan_Teleport;
	spriteList[PlayerSpriteType.TORNADO_BATTERY] = sprPlayerSkinRockMan_TornadoBattery;
	spriteList[PlayerSpriteType.TURNAROUND] = sprPlayerSkinRockMan_Turnaround;
	spriteList[PlayerSpriteType.WAVE_BIKE] = sprPlayerSkinRockMan_WaveBike;
	// Indirect
	spriteList[PlayerSpriteType.LIFE] = sprPlayerSkinRockMan_Life;
	spriteList[PlayerSpriteType.MUGSHOT] = sprPlayerSkinRockMan_Mugshot;
	
	// == Setup Frame Counts
	for (var i = 0; i < PlayerSpriteType.COUNT; i++) {
		spriteFrameCount[i] = sprite_get_number(spriteList[i]);
		
		if (i < PlayerSpriteType.COUNT_STANDARD)
			spriteFrameCount[i] /= PlayerShootType.COUNT;
		else if (i == PlayerSpriteType.SLASH_CLAW)
			spriteFrameCount[i] /= 3; // Ground, Air, Climb
		else if (i == PlayerSpriteType.TENGU_BLADE)
			spriteFrameCount[i] /= 4; // Ground, Air, Climb, Dash
	}
	
	// == Palette Initialize
	// (playerColours not included, since that's gonna be unique for each character anyway)
	//
	// Coil (also sets Jet colours by default)
	coilColours[PalettePlayer.primary] = $0028D8;
	coilColours[PalettePlayer.secondary] = $F8F8F8;
	coilColours[PalettePlayer.outline] = $000000;
	coilColours[PalettePlayer.skin] = $A8D8FC;
	coilColours[PalettePlayer.face] = $000000;
	coilColours[PalettePlayer.eyes] = $FFFFFF;
	
	// == Gun Offsets
	// Shooting/Throwing
	var _shootType = [PlayerShootType.SHOOT, PlayerShootType.THROW];
	for (var i = 0; i < 2; i++) {
		self.set_gun_offset(_shootType[i], PlayerSpriteType.IDLE, 17, 4);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.SIDESTEP, 17, 4);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.WALK, 16, 4);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.JUMP, 13, 3);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.FALL, 13, 3);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.SLIDE, 9, 2);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.CLIMB, 13, 2);
		self.set_gun_offset(_shootType[i], PlayerSpriteType.CLIMB_TOP, 13, 2);
	}
	// Shooting Up
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.IDLE, 5, -5);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.SIDESTEP, 5, -5);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.WALK, 10, -3);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.JUMP, 6, -5);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.FALL, 6, -5);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.SLIDE, 7, 0);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.CLIMB, 5, -7);
	self.set_gun_offset(PlayerShootType.SHOOT_UP, PlayerSpriteType.CLIMB_TOP, 5, -7);
	// Shooting Diagonal Up
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.IDLE, 15, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.SIDESTEP, 15, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.WALK, 13, -1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.JUMP, 12, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.FALL, 12, -2);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.SLIDE, 11, 1);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.CLIMB, 12, -4);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_UP, PlayerSpriteType.CLIMB_TOP, 12, -4);
	// Shooting Diagonal Down
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.IDLE, 14, 10);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.SIDESTEP, 14, 10);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.WALK, 11, 13);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.JUMP, 12, 10);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.FALL, 12, 10);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.SLIDE, 11, 10);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.CLIMB, 11, 9);
	self.set_gun_offset(PlayerShootType.SHOOT_DIAGONAL_DOWN, PlayerSpriteType.CLIMB_TOP, 11, 9);
	
	#endregion
}

/// @func cache_character_entities()
/// @desc Generates a cache of all the entities each playable character is represented by
///
/// @returns {array}  An array of the entities corresponding to each playable character.
function cache_character_entities() {
	return array_map(global.characterList, function(_characterScript, i) {
		var _character = new _characterScript(),
			_characterEntity = _character.entityObject;
		delete _character;
		return _characterEntity;
	});
}

/// @func character_create_from_id(id)
/// @desc Generates an instance of a playable character (i.e. a struct with info about that character)
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {Character}  A character instance
function character_create_from_id(_id) {
	return new global.characterList[_id]();
}

/// @func character_object_from_id(id)
/// @desc Gets the player object that represents the given character
///
/// @param {int}  id  The ID of the character, corresponding to the CharacterType enum
///
/// @returns {prtPlayer}  Object of the character
function character_object_from_id(_id) {
	return global.characterEntityList[_id];
}
