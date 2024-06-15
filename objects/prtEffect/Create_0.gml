// Lightweight object intended for visual effects
image_speed = 0;

var _pixelPerfect = options_data().pixelPerfect;
subPixelX = frac(x) * _pixelPerfect;
subPixelY = frac(y) * _pixelPerfect;

x = floor(x);
y = floor(y);