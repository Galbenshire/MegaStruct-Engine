if (array_empty(layers)) {
    instance_destroy();
    exit;
}

var _section = find_section_at(sprite_x_center(), sprite_y_center());
if (areaLeft == USE_SECTION_EDGE)
    areaLeft = (_section != noone) ? _section.left : 0;
if (areaTop == USE_SECTION_EDGE)
    areaTop = (_section != noone) ? _section.top : 0;
if (areaRight == USE_SECTION_EDGE)
    areaRight = (_section != noone) ? _section.right : room_width;
if (areaBottom == USE_SECTION_EDGE)
    areaBottom = (_section != noone) ? _section.bottom : room_height;

areaWidth = areaRight - areaLeft;
areaHeight = areaBottom - areaTop;

if (areaWidth <= 0 || areaHeight <= 0) {
    print_err($"objParallax ({x}, {y}) was initialized with an invalid area ({areaWidth} x {areaHeight}). It has been deleted.");
    instance_destroy();
    exit;
}

var _xAdjust = 0;
switch (alignX) {
    case "Left": _xAdjust = areaLeft; break;
    case "Center": _xAdjust = areaLeft + ((areaWidth - GAME_WIDTH) / 2); break;
    case "Right": _xAdjust = areaRight - GAME_WIDTH; break;
}
var _yAdjust = 0;
switch (alignY) {
    case "Top": _yAdjust = areaTop; break;
    case "Center": _yAdjust = areaTop + ((areaHeight - GAME_HEIGHT) / 2); break;
    case "Bottom": _yAdjust = areaBottom - GAME_HEIGHT; break;
}

var i = 0; repeat(layerCount) {
    layers[i].shift_by(offsetXAbsolute, offsetYAbsolute, false)
        .shift_by(offsetXRelative + _xAdjust, offsetYRelative + _yAdjust, true)
        .calculate_segments(areaWidth, areaHeight);
    i++;
}