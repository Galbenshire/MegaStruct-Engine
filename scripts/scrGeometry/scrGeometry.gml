// Credit to http://jeffreythompson.org/collision-detection/
// Most of the code here is based off of his work here

/// @func line_line_overlaps(x1, y1, x2, y2, x3, y3, x4, y4)
/// @desc Looks for a point of intersection
///       on one line (x1, y1, x2, y2) with another line (x3, y3, x4, y4)
///
/// @param {number}  x1  The x coordinate of the start of the first line.
/// @param {number}  y1  The y coordinate of the start of the first line.
/// @param {number}  x2  The x coordinate of the end of the first line.
/// @param {number}  y2  The y coordinate of the end of the first line.
/// @param {number}  x3  The x coordinate of the start of the second line.
/// @param {number}  y3  The y coordinate of the start of the second line.
/// @param {number}  x4  The x coordinate of the end of the second line.
/// @param {number}  y4  The y coordinate of the end of the second line.
///
/// @returns {Vector2?}  The point of intersection between the two lines
///                     If no intersection is found, `undefined` is returned
function line_line_intersects(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4) {
    var _uDiv = (_y4 - _y3) *  (_x2 - _x1) - (_x4 - _x3) * (_y2 - _y1),
        _uA = ((_x4 - _x3) * (_y1 - _y3) - (_y4 - _y3) *  (_x1 - _x3)) / _uDiv,
        _uB = ((_x2 - _x1) * (_y1 - _y3) - (_y2 - _y1) *  (_x1 - _x3)) / _uDiv;
    
    if (_uA >= 0 && _uA <= 1 && _uB >= 0 && _uB <= 1) {
        var _intersectX = _x1 + (_uA * (_x2 - _x1)),
            _intersectY = _y1 + (_uA * (_y2 - _y1));
        return [_intersectX, _intersectY];
    }
    
    return undefined;
}

/// @func line_line_overlaps(x1, y1, x2, y2, x3, y3, x4, y4)
/// @desc Checks for an overlap on one line (x1, y1, x2, y2) with another line (x3, y3, x4, y4)
///
/// @param {number}  x1  The x coordinate of the start of the first line.
/// @param {number}  y1  The y coordinate of the start of the first line.
/// @param {number}  x2  The x coordinate of the end of the first line.
/// @param {number}  y2  The y coordinate of the end of the first line.
/// @param {number}  x3  The x coordinate of the start of the second line.
/// @param {number}  y3  The y coordinate of the start of the second line.
/// @param {number}  x4  The x coordinate of the end of the second line.
/// @param {number}  y4  The y coordinate of the end of the second line.
///
/// @returns {bool}  Whether there's an overlap (true) or not (false)
function line_line_overlaps(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4) {
    var _uDiv = (_y4 - _y3) *  (_x2 - _x1) - (_x4 - _x3) * (_y2 - _y1);
    var _uA = ((_x4 - _x3) * (_y1 - _y3) - (_y4 - _y3) *  (_x1 - _x3)) / _uDiv;
    var _uB = ((_x2 - _x1) * (_y1 - _y3) - (_y2 - _y1) *  (_x1 - _x3)) / _uDiv;
    return (_uA >= 0 && _uA <= 1 && _uB >= 0 && _uB <= 1);
}
