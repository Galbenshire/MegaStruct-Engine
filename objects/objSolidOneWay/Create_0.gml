// Need a solid that only blocks in one direction?
// You need an objSolidOneWay.
// Simply place it down in the room, then rotate it
// until the white side is in the direction you want solid.
//
// Note: only works in the cardinal directions (i.e. up, down, left, right)
event_inherited();

image_angle = round_to(wrap_angle(image_angle), 90);

switch (image_angle) {
	case 0: solidType = SolidType.TOP_SOLID; break;
	case 90: solidType = SolidType.LEFT_SOLID; break;
	case 180: solidType = SolidType.BOTTOM_SOLID; break;
	case 270: solidType = SolidType.RIGHT_SOLID; break;
}
