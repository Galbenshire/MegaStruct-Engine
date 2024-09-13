/// @description Generate more eggs
if (!autoGenerate)
    exit;

var _width = image_xscale,
    _height = image_yscale,
    _x = x,
    _y = y;

image_xscale = 1;
image_yscale = 1;
autoGenerate = false;

for (var i = 0; i < _width; i++) {
    for (var j = 0; j < _height; j++) {
        x = _x + i * sprite_width;
        y = _y + j * sprite_height;
        xstart = x;
        ystart = y;
        
        var _temp = instance_copy(true);
        _temp.depth = depth;
    }
}

instance_destroy();
