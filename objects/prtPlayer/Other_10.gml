/// @description Update Gun Offset
switch (shootAnimation) {
	default:
		gunOffsetX = 17 - 4 * !ground;
		gunOffsetY = 4 - !ground;
		break;
	case 3: // Aim Up
		gunOffsetX = 5 + !ground;
		gunOffsetY = -5 - isClimbing;
		break;
	case 4: // Aim Diagonal Up
		gunOffsetX = 14 - (3 * !ground);
		gunOffsetY = -1 - isClimbing;
		break;
	case 5: // Aim Diagonal Down
		gunOffsetX = 13 - (2 * !ground);
		gunOffsetY = 9 - isClimbing;
		break;
}