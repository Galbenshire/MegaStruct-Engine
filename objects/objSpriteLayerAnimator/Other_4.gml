if (spriteTypeCount <= 0) {
    show_debug_message($"No sprite types specified for objSpriteLayerAnimator ({x}, {y})");
    instance_destroy();
    exit;
}

event_user(0);