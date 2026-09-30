/// @description Entity Tick
if (boingTimer > 0) {
    image_index += 0.25;
    boingTimer--;
    
    if (boingTimer <= 0)
        image_index = 0;
    
    exit;
}

xspeed.value = slowSpeed * image_xscale;
if (reticle.targetExists) {
    if (reticle.target.ground && reticle.target.bbox_bottom == bbox_bottom)
        xspeed.value = fastSpeed * image_xscale;
}