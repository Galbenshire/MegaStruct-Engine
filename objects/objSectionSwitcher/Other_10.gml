/// @description Move Camera
xspeed.update();
yspeed.update();
x += xspeed.integer;
y += yspeed.integer;

gameViewRef.set_prev_position(gameViewRef.xView, gameViewRef.yView);
gameViewRef.set_position(x, y);