// Lightweight object intended for visual effects

xspeed = new Fractional(); /// @is {Fractional}
yspeed = new Fractional(); /// @is {Fractional}

var _pixelPerfect = options_data().pixelPerfect;
subPixelX = frac(x) * _pixelPerfect;
subPixelY = frac(y) * _pixelPerfect;

__isDestroyed = false;

x = floor(x);
y = floor(y);
image_speed = 0;