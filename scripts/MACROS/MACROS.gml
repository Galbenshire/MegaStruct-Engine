// ===== Engine Configurations =====

#macro DEBUG_ENABLED true // Enables various debug keys & features (should be false for a release build)
#macro GAME_SPEED 60 // How fast the game is expected to be (in FPS)
#macro GAME_WIDTH 256 // Resolution width of the game (in pixels)
#macro GAME_HEIGHT 224 // Resolution height of the game (in pixels)

// ===== -1 Aliases =====

#macro INFINITE_RANGE -1
#macro INFINITE_I_FRAMES -1
#macro NO_CONTROLLER -1
#macro NOT_FOUND -1

// ===== Macro Functions =====

#macro ENFORCE_SINGLETON static __init = 0;\
__init++;\
assert(__init == 1, "Only one instance of {0} can be present at any time.", instanceof(self));
