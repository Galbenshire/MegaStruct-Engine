if (spriteTypeCount <= 0) {
    show_debug_message("No sprite types specified for objSpriteLayerAnimator");
    instance_destroy();
    exit;
}

event_user(0);