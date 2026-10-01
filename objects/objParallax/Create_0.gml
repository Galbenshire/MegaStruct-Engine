// This object will draw a set of sprites at an offset from the position of the foreground.
// This effect is known as "parallax", and can help give off the illusion of depth.

// Most of this code is based off of Megamix parallax code by InUni.

#region Variables

layers = [];
layerCount = 0;

areaWidth = 0;
areaHeight = 0;

timer = 0;

pauseMask = PauseType.PAUSEMENU | PauseType.TIMESCALE | PauseType.HITSTUN;

#endregion

#region Functions

/// -- add_parallax_layer(sprite, index)
/// Adds a new layer to this parallax object
function add_parallax_layer(_sprite, _index = 0) {
    var _layer = new ParallaxLayer(_sprite, _index);
    array_push(layers, _layer);
    layerCount++;
    return _layer;
}

/// -- set_all_speed(xspeed, yspeed)
/// Sets the move speed of each layer. Parallax values will be factored in.
function set_all_speed(_xspeed, _yspeed) {
    var i = 0; repeat(layerCount) {
        layers[i].set_speed(_xspeed, _yspeed, true);
        i++;
    }
}

/// -- shift_all_by(x, y, relative)
/// Shifts all layers by a specific amount, taking their parallax values into account if desired
function shift_all_by(_x, _y, _relative = true) {
    var i = 0; repeat(layerCount) {
        layers[i].shift_by(_x, _y, _relative);
        i++;
    }
}

#endregion