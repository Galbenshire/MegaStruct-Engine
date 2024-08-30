if (global.paused && !global.switchingSections)
    exit;

var i = 0;
repeat(layerCount) {
    with (layers[i]) {
        x += speedX;
        y += speedY;
    }
    i++;
}