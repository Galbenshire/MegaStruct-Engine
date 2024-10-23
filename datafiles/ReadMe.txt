==== MegaStruct Engine ====
Mega Man framework made in GameMaker Studio 2.3
Designed to make use out of the many features 2.3 offers over 1

=== PLAYABLE CHARACTERS ===
- Mega Man
  Standard Mega Man beaviour
- Proto Man
  Slightly more agile then his brother
  Has a shield that deflects most shots when jumping (Proto Shield-style reflecting not yet implemented)
  His feet are a bit slippery tho, and he takes more damage from stuff
- Bass
  Instead of a charging Buster, he has a aimable, rapid-fire one
  He can also dash boost, & double-jump (jumps are slightly shorter to compensate)
  
=== STAGES ===
- Cut Man (MM1)
- Metal Man (MM2)
- Gemini Man (MM3)
- Test Stage

=== CONTROLS ===
~~ Keyboard
- Left/Right/Up/Down: Arrow Keys
- Jump: Z
- Shoot: X
- Slide: C
- Weapon Switch Left/Right: A/S
- Pause: Enter

~~ Gamepad (assuming an Xbox Controller)
- Left/Right/Up/Down: D-Pad
- Jump: A
- Shoot: X
- Slide: B
- Weapon Switch Left/Right: LT/RT
- Pause: Start

~~ Debug Keys
- Esc
  Quits the game
- F1
  Restarts the game
- F2
  Changes the screen size
- F3
  Toggles fullscreen
- F4
  Toggles pixel perfect resolution
- F5
  Toggles the debug overlay
  In addition to the standard features, three custom views are available here
    - A view to edit options data on the fly
    - A room selector
	- The ability to take a "snapshot", listing all the entities active at the time of the "snapshot"
- F6
  Toggles between 60FPS & 1FPS
- F7
  Toggles "Free Roam Camera" mode
  Use the numpad to move the camera around
- F7+Shift
  Toggles a map. Allows for warping to various checkpoints across the level
  This only works inside of a level
  Numpad 2,4,6,8 moves the map
  Numpad 7 & 9 selects a checkpoint from the level
  Numpad 0 warps to the currently selected checkpoint
- F8
  Toggles the visibility of various dev layers
  (i.e. collision objects, sections, transition objects, etc.)
  This only works inside of a level
- F9
  Toggles a "Free Movement" mode for player entities controlled by the player user
  They can be moved about throughout the level, intangible to anything
- F10
  Take a screenshot