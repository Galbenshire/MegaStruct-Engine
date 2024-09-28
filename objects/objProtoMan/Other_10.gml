/// @description Update Gun Offset
switch (shootAnimation) {
	default:
		gunOffsetX = 10 + (2 * isClimbing);
		gunOffsetY = 6 + !ground - (2 * isClimbing);
		break;
	case 3: // Aim Up
		gunOffsetX = 8 + (!ground && !isClimbing);
		gunOffsetY = -4 - (4 * isClimbing);
		break;
	case 4: // Aim Diagonal Up
		gunOffsetX = 12 - !ground - isClimbing;
		gunOffsetY = 3 - (5 * !ground) + isClimbing;
		break;
	case 5: // Aim Diagonal Down
		gunOffsetX = 10 + !ground;
		gunOffsetY = 11 - (3 * isClimbing);
		break;
}