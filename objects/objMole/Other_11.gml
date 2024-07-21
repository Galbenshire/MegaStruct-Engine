/// @description Emit Sparks
if (!emitSparks)
    exit;

var _sprite = sprite_index,
    _x = x,
    _y = y,
    _sparkY = undefined;

if (burrowBitField == 0b01) { // Is burying into solid geometry?
    sprite_index = sprLine;
    y -= 12 * image_yscale;
    move_and_collide_y(24 * image_yscale);
    _sparkY = y;
}

if (burrowBitField == 0b10) { // Is emerging out of solid geometry?
    sprite_index = sprLine;
    y += 12 * image_yscale;
    move_and_collide_y(-24 * image_yscale);
    _sparkY = y;
}

if (!is_undefined(_sparkY)) {
    var _spark = instance_create_layer(x, _sparkY, LAYER_COLLISION, objMoleSpark);
    _spark.myMole = self;
    _spark.depth -= 1;
}

sprite_index = _sprite;
x = _x;
y = _y;