/// @description Insert description here
if (phase == 0 && ycoll != 0) {
    phase = 1;
    yspeed.value = 0;
    animator.play("teleport-in");
    play_sfx(sfxTeleportIn);
}

animator.update();
