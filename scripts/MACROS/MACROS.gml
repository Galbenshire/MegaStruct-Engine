#region _Engine Configurations

#macro DEBUG_ENABLED true // Enables various debug keys & features (should be false for a release build)
#macro GAME_SPEED 60 // How fast the game is expected to be (in FPS)
#macro GAME_WIDTH 256 // Resolution width of the game (in pixels)
#macro GAME_HEIGHT 224 // Resolution height of the game (in pixels)
#macro CONSOLE_MAX_LINES 16 // Maximum number of lines allowed in the debug console

#endregion


#region _Macro Functions

#macro ENFORCE_SINGLETON static __init = 0;\
__init++;\
assert(__init == 1, $"Only one instance of {instanceof(self)} can be present at any time.");

#macro DEBUG_VIEW_HTML5_CHECK if (is_html5()) { return; }

#macro PLAYER_ONLY_FUNCTION assert(is_a_player(_player),\
$"{_GMFUNCTION_} can only be used by an object that inherits from {object_get_name(prtPlayer)}");

#endregion


#region -1 Aliases

#macro INFINITE_RANGE -1
#macro INFINITE_I_FRAMES -1
#macro NO_CONTROLLER -1
#macro NO_SURFACE -1
#macro NOT_FOUND -1
#macro USE_SECTION_EDGE -1

#endregion


#region Colour Replacer

enum ColourReplacerMode {
	GREYSCALE,
	RGB,
	RGB_SINGLE,
	
	COUNT
}

#macro COLOUR_REPLACER_MAX_COLOURS 32

#endregion


#region Characters

// All playable characters available in this engine

enum CharacterType {
	MEGA,
	PROTO,
	BASS,
	
	COUNT
}

#endregion


#region Entity Macros

// The list of factions an entity can be a part of, or can target, in this game
enum Faction {
	PICKUP = 1 << 0,
	PLAYER = 1 << 1,
	PLAYER_PROJECTILE = 1 << 2,
	ENEMY = 1 << 3,
	ENEMY_PROJECTILE = 1 << 4,
	NEUTRAL = 1 << 5,
	NEUTRAL_PROJECTILE = 1 << 6,
	
	// Shortcuts
	PLAYER_FULL = Faction.PLAYER | Faction.PLAYER_PROJECTILE,
	ENEMY_FULL = Faction.ENEMY | Faction.ENEMY_PROJECTILE,
	NEUTRAL_FULL = Faction.NEUTRAL | Faction.NEUTRAL_PROJECTILE
}

// Determines what an entity can drop
enum ItemDropType {
	// Drop Nothing
	NONE,
	
	// Drop from a random table
	RANDOM,
	
	// User can determine what is dropped
	CUSTOM
}

// The life states entities can have.
// Used to flag if an entity is active, and is also used for spawning
enum LifeState {
	// The entity is not dead.
	// It can run its step code, interact with other entities, and can be drawn
	ALIVE,
	
	// This entity has been recently killed.
	// It is intangible, inactive, & invisible.
	// It must be scrolled offscreen before it can start respawning.
	DEAD_ONSCREEN,
	
	// This entity is dead.
	// Similar to DEAD_ONSCREEN, except it can now respawn if scrolled back onscreen.
	DEAD_OFFSCREEN
}

// Represents the "level" of respawning an entity is capable of
enum RespawnType {
	// Can always respawn
	ENABLED,
	
	// Respawning is disabled upon death. Regained on section switched
	DISABLE_ON_DEATH,
	
	// Entity is destroyed on death (but not from despawning)
	DESTROY_ON_DEATH,
	
	// Entity is destroyed on either death or despawn
	DISABLED
}

// Represents the presets available when setting up an entity's Reticle
enum ReticlePresetType {
	NO_TARGET,
	GENERIC,
	NEAREST,
	SWITCH_REGULARLY,
	PICK_ONCE,
	CUSTOM
}

// Represents how entities react during a section switch
enum SectionSwitchBehaviour {
	// The entity will be deactivated right as the section switch occurs
	HIDDEN,
	
	// The entity will still be visible during a section switch
	// It only gets deactivated if not in the new section once the switch is done
	VISIBLE,
	
	// The entity will never be deactivated during a section switch
	PERSISTANT
}

#endregion


#region Entity-Entity Collisions

// Denotes various attributes of an entity attack
enum DamageFlags {
	NO_DAMAGE = 1 << 0,
	MOCK_DAMAGE = 1 << 1
}

// How an entity should guard against an attack
enum GuardType {
	DAMAGE,
	REFLECT,
	IGNORE,
	REFLECT_OR_IGNORE,
	FORCE_REFLECT
}

// Denotes how an entity should react to being guarded
enum PenetrateType {
	NONE,
	NO_DAMAGE,
	NO_DAMAGE_AND_COLLISION,
	BYPASS_GUARD
}

// Denotes if an entity should be killed after dealing damage
enum PierceType {
	NEVER,
	ON_KILLS_ONLY,
	ALWAYS
}

#endregion


#region Input

enum InputActions {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	
	JUMP,
	SHOOT,
	SLIDE,
	
	WEAPON_SWITCH_LEFT,
	WEAPON_SWITCH_RIGHT,
	
	PAUSE,
	
	COUNT
}

#endregion


#region Layer Names

#macro LAYER_COLLISION "_Collision"
#macro LAYER_ENTITY "_Entities"
#macro LAYER_FADER "_Fader"
#macro LAYER_SECTION "_Sections"
#macro LAYER_SECTION_GRID "_SectionGrid"
#macro LAYER_SYSTEM "_System"
#macro LAYER_TRANSITION "_Transitions"

#endregion


#region Music

// IDs of each piece of music in the engine
enum Music {
	// Mega Man 1
	MM1_CUTMAN,
	MM1_BOSSRM,
	
	// Mega Man 2
	MM2_METALMAN,
	MM2_BOSS,
	
	// Mega Man 3
	MM3_GEMINIMAN,
	MM3_BOSSRM,
	
	// Mega Man 5
	MM5_TITLE_SCREEN,
	MM5_PASSWORD,
	
	COUNT
}

#endregion


#region Physics

// The types of solids in this engine
enum SolidType {
	// Entities will pass through collidables with this value
	NOT_SOLID,
	
	// Solid in all directions
	SOLID,
	
	// Directional solids, only solid in one direction
	TOP_SOLID,
	BOTTOM_SOLID,
	LEFT_SOLID,
	RIGHT_SOLID,
	
	// Acts as a "top" solid, relative to the collider's direction of gravity
	GRAV_DIR_SOLID,
	
	// Slopes are treated differently, as we can move up/down them
	SLOPE,
	
	// We'll need a special type of solid to make moving up slopes work
	SLOPE_SOLID
}

#macro DEFAULT_GRAVITY 0.25
#macro DEFAULT_GRAVITY_DIRECTION 1
#macro DEFAULT_GRAVITY_WATER_MODIFIER 0.57
#macro DEFAULT_FALL_SPEED 7
#macro DEFAULT_MAX_SLOPE_STEEPNESS 1

#endregion


#region Player-related Macros

// Represents various actions a player can perform
// Used by the lockstack system
enum PlayerAction {
	// If locked, the player entity will no longer standard entity physics
	// (i.e. no colliding with solids, no gravity, no interaction with water)
	PHYSICS,
	
	// If locked, the player will no longer experience gravity
	GRAVITY,
	
	// Halts player movement on the ground if locked
	MOVE_GROUND,
	
	// Halts player movement in the air if locked
	MOVE_AIR,
	
	// Prevents turning on the ground if locked
	TURN_GROUND,
	
	// Prevents turning in the air if locked
	TURN_AIR,
	
	// If locked, the player can no longer jump (also covers jumping off a ladder)
	JUMP,
	
	// If locked, the player can no longer climb (covers both getting on a ladder, and moving on one)
	CLIMB,
	
	// Disables sliding if locked
	SLIDE,
	
	// Disables shootin if locked
	SHOOT,
	
	// Disables weapon charging if locked
	CHARGE,
	
	// If locked, the player's animations are frozen to the last state they were in
	SPRITE_CHANGE,
	
	// Disables weapon quick switching if locked
	WEAPON_CHANGE,
	
	// If locked, the player entity can no longer receive input from the player user
	// (does not prevent input from other sources)
	INPUT,
	
	// The number of player actions in the system
	COUNT,
	
	//-- Special Shortcuts
	// Covers both MOVE_GROUND and MOVE_AIR
	MOVE_FULL,
	// Covers both TURN_GROUND and TURN_AIR
	TURN_FULL
}

// Animation Enums

enum PlayerAnimationType {
	// The Main Ones
	STANDARD,
	HURTSTUN,
	TELEPORT,
	
	// Weapons
	BREAK_DASH,
	SLASH_CLAW,
	TENGU_BLADE,
	TOP_SPIN,
	
	// Misc. Actions
	TORNADO_BATTERY,
	TURNAROUND,
	WAVE_BIKE,
	
	COUNT
}

enum PlayerStandardAnimationSubType {
	IDLE,
	SHOOT,
	THROW,
	SHOOT_UP,
	SHOOT_DIAGONAL_UP,
	SHOOT_DIAGONAL_DOWN,
	SUPER_ARM,
	WIRE_ADAPTOR,
	
	COUNT
}

// Standard Animation Key Frames
#macro PLAYER_ANIM_FRAME_IDLE 0
#macro PLAYER_ANIM_FRAME_SIDESTEP 2
#macro PLAYER_ANIM_FRAME_WALK 3
#macro PLAYER_ANIM_FRAME_JUMP 7
#macro PLAYER_ANIM_FRAME_FALL 9
#macro PLAYER_ANIM_FRAME_SLIDE 11
#macro PLAYER_ANIM_FRAME_CLIMB 13
#macro PLAYER_STANDARD_FRAME_COUNT 16

// Player Physics
#macro COYOTE_FALL_BUFFER 4
#macro FULL_HEALTHBAR 28
#macro JUMP_BUFFER 4
#macro DEFAULT_ICE_DECEL_IDLE 0.025
#macro DEFAULT_ICE_DECEL_WALK 0.03
#macro QUICK_TURN_BUFFER 2

#endregion


#region Tuples

// These enums represent fixed-size arrays
// Could be more useful than structs at times, since they use less memory

enum CheckpointData {
	room, /// @is {room}
	x, /// @is {number}
	y, /// @is {number}
	dir, /// @is {number}
	name, /// @is {string}
	sizeof
}

enum ColourChannels {
	red, /// @is {int}
	green, /// @is {int}
	blue, /// @is {int}
	sizeof
}

enum ConsoleLine {
	text, /// @is {string}
	colour, /// @is {int}
	lifetime, /// @is {int}
	alpha, /// @is {number}
	sizeof
}

enum Line {
	x1, /// @is {number}
	y1, /// @is {number}
	x2, /// @is {number}
	y2, /// @is {number}
	sizeof
}

enum MusicSnapshot {
	musicID, /// @is {int}
	startAt, /// @is {number}
	volume, /// @is {number}
	sizeof
}

enum MusicTrack {
	asset, /// @is {sound}
	loops, /// @is {bool}
	loopStart, /// @is {number}
	loopEnd, /// @is {number}
	sizeof
}

enum PalettePlayer {
	primary, /// @is {int}
	secondary, /// @is {int}
	outline, /// @is {int}
	
	skin, /// @is {int}
	face, /// @is {int}
	eyes, /// @is {int}
	
	primaryShaded, /// @is {int}
	secondaryShaded, /// @is {int}
	skinShaded, /// @is {int}
	
	sizeof
}

enum PaletteThreeTone {
	primary, /// @is {int}
	secondary, /// @is {int}
	background, /// @is {int}
	sizeof
}

enum PaletteTwoTone {
	primary, /// @is {int}
	secondary, /// @is {int}
	sizeof
}

enum PaletteWeapon {
	primary, /// @is {int}
	secondary, /// @is {int}
	outline, /// @is {int}
	skintone, /// @is {int}
	highlight, /// @is {int}
	sizeof
}

enum ParallaxLayer {
	sprite, /// @is {sprite}
	index, /// @is {int}
	x, /// @is {number}
	y, /// @is {number}
	parallaxX, /// @is {number}
	parallaxY, /// @is {number}
	speedX, /// @is {number}
	speedY, /// @is {number}
	wrapX, /// @is {bool}
    wrapY, /// @is {bool}
    left, /// @is {int}
    top, /// @is {int}
    width, /// @is {int}
    height, /// @is {int}
    widthSegments, /// @is {int}
    heightSegments, /// @is {int}
    isWholeSprite, /// @is {bool}
	sizeof
}

enum RefillQueueItem {
	player, /// @is {prtPlayer}
	target, /// @is {Weapon?}
	amount, /// @is {number}
	sizeof
}

enum ScreenFlashNote {
	alpha, /// @is {number}
	colour, /// @is {int}
	timer, /// @is {int}
	gain, /// @is {number}
	decay, /// @is {number}
	step, /// @is {number}
	isDone, /// @is {bool}
	sizeof
}

enum ScreenShakeNote {
	strengthX, /// @is {number}
	strengthY, /// @is {number}
	timer, /// @is {int}
	decay, /// @is {number}
	isDone, /// @is {bool}
	sizeof
}

enum SpriteAtlasCell {
    sheetX, /// @is {int}
    sheetY, /// @is {int}
    indexX, /// @is {int}
    indexY, /// @is {int}
    sizeof
}

enum Vector2 {
	x, /// @is {number}
	y, /// @is {number}
	sizeof
}

enum WeightedOutcome {
	value, /// @is {any}
	weight, /// @is {number}
	sizeof
}

#endregion


#region User Event Reserves

// prtEntity
#macro EVENT_ENTITY_TICK 14
#macro EVENT_ENTITY_POSTTICK 15
// prtBoss
#macro EVENT_BOSS_METHOD_INIT 11
#macro EVENT_BOSS_ANIMATION_INIT 12
#macro EVENT_BOSS_STATEMACHINE_INIT 13
// prtPlayer
#macro EVENT_PLAYER_METHOD_INIT 11
#macro EVENT_PLAYER_ANIMATION_INIT 12
#macro EVENT_PLAYER_STATEMACHINE_INIT 13
// prtInterval
#macro EVENT_INTERVAL_ACTION 15
// prtEffect
#macro EVENT_EFFECT_DRAW_FRAME 14
#macro EVENT_EFFECT_TICK 15

#endregion


#region Weapons

// Macros relating to player weapons

enum WeaponType {
	BUSTER,
	BUSTER_PROTO,
	BUSTER_BASS,
	RUSH_COIL,
	RUSH_JET,
	ICE_SLASHER,
	METAL_BLADE,
	SEARCH_SNAKE,
	SKULL_BARRIER,
	
	COUNT
}

enum WeaponFlags {
	// Ammo pickups have no effect, there's no ammo bar on the HUD, & Tanks ignore this weapon entirely
	NO_AMMO = 1 << 0,
	// Weapon is chargeable (e.g. the Mega Buster (if you're not basic))
	CHARGE = 1 << 1
}

#endregion


#region _Misc

// -- Angle directions from 4 enum values (multiply by 90 to get the angle)
enum AngleDir {
	RIGHT,
	UP,
	LEFT,
	DOWN
}

// -- Defer Event Types
enum DeferType {
	STEP,
	STEP_BEGIN,
	STEP_END,
	
	DRAW,
	DRAW_BEGIN,
	DRAW_END,
	
	DRAW_GUI,
	DRAW_GUI_BEGIN,
	DRAW_GUI_END,
	
	ROOM_START,
	ROOM_END
}

// -- Warning Level
enum WarningLevel {
	SHOW,
	ERROR,
	VERBOSE
}

// -- Pausing
#macro QUEUED_PAUSE 1
#macro QUEUED_UNPAUSE -1

#endregion
