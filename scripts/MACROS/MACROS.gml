// ===== Engine Configurations =====

#macro DEBUG_ENABLED true // Enables various debug keys & features (should be false for a release build)
#macro GAME_SPEED 60 // How fast the game is expected to be (in FPS)
#macro GAME_WIDTH 256 // Resolution width of the game (in pixels)
#macro GAME_HEIGHT 224 // Resolution height of the game (in pixels)

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

enum InputState {
	NONE,
	HELD,
	PRESSED,
	RELEASED
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

// ===== Health =====

#macro FULL_HEALTHBAR 28

// ===== -1 Aliases =====

#macro INFINITE_RANGE -1
#macro INFINITE_I_FRAMES -1
#macro NO_CONTROLLER -1
#macro NOT_FOUND -1

// ===== Macro Functions =====

#macro ENFORCE_SINGLETON static __init = 0;\
__init++;\
assert(__init == 1, "Only one instance of {0} can be present at any time.", instanceof(self));
