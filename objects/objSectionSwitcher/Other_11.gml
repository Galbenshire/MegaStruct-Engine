/// @description Move Camera
x += xspeed;
y += yspeed;

gameViewRef.set_prev_position(gameViewRef.xView, gameViewRef.yView);
gameViewRef.set_position(x, y);