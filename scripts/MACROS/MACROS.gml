// ===== Engine Configurations =====

#macro DEBUG_ENABLED true // Enables various debug keys & features (should be false for a release build)
#macro GAME_SPEED 60 // How fast the game is expected to be (in FPS)
#macro GAME_WIDTH 256 // Resolution width of the game (in pixels)
#macro GAME_HEIGHT 224 // Resolution height of the game (in pixels)

// ===== Characters =====

enum CharacterType {
	MEGA,
	PROTO,
	BASS,
	
	COUNT
}

// ===== Weapons =====

enum WeaponType {
	BUSTER,
	ICE_SLASHER,
	METAL_BLADE,
	
	COUNT
}

enum WeaponFlags {
	// Ammo pickups have no effect, there's no ammo bar on the HUD, & Tanks ignore this weapon entirely
	NO_AMMO = 1 << 0,
	// Weapon is chargeable (e.g. the Mega Buster (if you're not basic))
	CHARGE = 1 << 1
}

// ===== Input =====

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

// ===== Layer Names =====

#macro LAYER_COLLISION "_Collision"
#macro LAYER_ENTITY "_Entities"
#macro LAYER_FADER "_Fader"
#macro LAYER_SECTION "_Sections"
#macro LAYER_SECTION_GRID "_SectionGrid"
#macro LAYER_SYSTEM "_System"
#macro LAYER_TRANSITION "_Transitions"

// ===== Pause Queuing =====

#macro QUEUED_PAUSE 1
#macro QUEUED_UNPAUSE -1

// ===== Solid Collision =====

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

// ===== Entity Collision =====

enum DamageFlags {
	NO_DAMAGE = 1 << 0,
	MOCK_DAMAGE = 1 << 1
}

enum GuardType {
	DAMAGE,
	REFLECT,
	IGNORE,
	REFLECT_OR_IGNORE,
	FORCE_REFLECT
}

enum PenetrateType {
	NONE,
	NO_DAMAGE,
	NO_DAMAGE_AND_COLLISION,
	BYPASS_GUARD
}

enum PierceType {
	NEVER,
	ON_KILLS_ONLY,
	ALWAYS
}

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

// ===== Sections =====

enum SectionSwitchBehaviour {
	HIDDEN,
	VISIBLE,
	PERSISTANT
}

// ===== Physics =====

// -- General
#macro DEFAULT_GRAVITY 0.25
#macro DEFAULT_GRAVITY_DIRECTION 1
#macro DEFAULT_GRAVITY_WATER_MODIFIER 0.57
#macro DEFAULT_FALL_SPEED 7
#macro MAX_SLOPE_STEEPNESS 1

// -- Player Specific
#macro COYOTE_FALL_BUFFER 6
#macro JUMP_BUFFER 4

// ===== State Machine Enums =====

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

// ===== Health =====

#macro FULL_HEALTHBAR 28

// ===== User Event Reserves =====

#macro EVENT_ENTITY_TICK 14
#macro EVENT_ENTITY_POSTTICK 15

#macro EVENT_ANIMATION_INIT 12
#macro EVENT_STATEMACHINE_INIT 13

#macro EVENT_CHARACTER_SETUP ev_user10
#macro EVENT_WEAPON_SETUP ev_user10

#macro EVENT_INTERVAL_ACTION 14

// ===== -1 Aliases =====

#macro INFINITE_RANGE -1
#macro INFINITE_I_FRAMES -1
#macro NO_CONTROLLER -1
#macro NOT_FOUND -1

// ===== Tuples =====

enum SpriteAtlasCell {
    sheetX, /// @is {int}
    sheetY, /// @is {int}
    indexX, /// @is {int}
    indexY, /// @is {int}
    sizeof
}

enum PlayerPalette {
	primary, /// @is {int}
	secondary, /// @is {int}
	outline, /// @is {int}
	
	skin, /// @is {int}
	face, /// @is {int}
	eyes, /// @is {int}
	
	sizeof
}

// ===== Macro Functions =====

#macro ENFORCE_SINGLETON static __init = 0;\
__init++;\
assert(__init == 1, "Only one instance of {0} can be present at any time.", instanceof(self));
