// Use this object to set up your transitions between screen sections

image_angle = round_to(wrap_angle(image_angle), 90);
image_alpha = 0.5;
centerX = bbox_x_center(); /// @is {number}
centerY = bbox_y_center(); /// @is {number}

// Find out what section this instance will lead to
var _searchX = centerX,
    _searchY = centerY;
switch (image_angle) {
	case 0: _searchX += 8; break;
	case 90: _searchY -= 8; break;
	case 180: _searchX -= 8; break;
	case 270: _searchY += 8; break;
}
section = find_section_at(_searchX, _searchY); /// @is {objSection}
