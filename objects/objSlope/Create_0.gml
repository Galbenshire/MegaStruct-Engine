event_inherited();

steepness = image_yscale / image_xscale;

var _slopeLine = slope_line(id);
normal = point_direction(_slopeLine[Line.x1], _slopeLine[Line.y1], _slopeLine[Line.x2], _slopeLine[Line.y2]);
normal = wrap_angle(normal - 90);