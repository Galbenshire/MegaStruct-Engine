var _edge = bbox_edge_line(edgeDir);
var _edgex1 = _edge[Line.x1],
	_edgey1 = _edge[Line.y1],
var _edgex2 = _edge[Line.x2],
	_edgey2 = _edge[Line.y2];
var _edgeAngle = point_direction(_edgex1, _edgey1, _edgex2, _edgey2),
    _mouseAngle = point_direction(mouse_x, mouse_y, bbox_x_center(), bbox_y_center());

draw_self();
draw_line_width_colour(_edgex1, _edgey1, _edgex2, _edgey2, 2, c_red, c_green);
draw_line_width_colour(mouse_x, mouse_y, bbox_x_center(), bbox_y_center(), 1, c_yellow, c_blue);

draw_text(bbox_x_center(), bbox_y_center() + 24, angle_difference(_edgeAngle, _mouseAngle));