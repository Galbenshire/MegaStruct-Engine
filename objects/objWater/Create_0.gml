splashDirection = array_reduce(splashDirection, function(_prev, _curr, i) /*=>*/ {return _prev | (1 << _curr)}, 0); /// @is {int}

// A reference to the "lines" that make up the bounding box,
// in the format of <x1, y1, x2, y2>.
// This is mainly used to calculate splash positions.
lines = [
    [bbox_right, bbox_top, bbox_right, bbox_bottom], // Right
    [bbox_left, bbox_top, bbox_right, bbox_top], // Top
    [bbox_left, bbox_top, bbox_left, bbox_bottom], // Left
    [bbox_left, bbox_bottom, bbox_right, bbox_bottom] // Bottom
]; /// @is {array<Line>}
