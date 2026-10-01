/// @description Tick
animator.update();

if (isMoving) {
    with (target)
        other.ystart = y + other.targetOffsetY;
    
    if (!inside_view() && game_view().direction_to_center_y(y) == sign(yspeed))
        destroyOutsideView = true;
    
    if ((y - ystart) * sign(yspeed) >= 0 && (target == noone || instance_exists(target))) {
        y = ystart;
        isMoving = false;
        yspeed = 0;
        animator.play("teleport-in");
        
        if (teleportSFX != noone)
            play_sfx(teleportSFX);
    }
} else {
    with (target) {
        other.x = x + other.targetOffsetX;
        other.y = y + other.targetOffsetY;
    }
    
    if (animator.is_animation_finished())
        instance_destroy();
}