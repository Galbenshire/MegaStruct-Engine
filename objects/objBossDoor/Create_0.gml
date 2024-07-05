event_inherited();

transitions = instance_place_array(x, y, objScreenTransition, false);
transitionCount = array_length(transitions);

if (transitionCount <= 0) {
    instance_destroy();
    exit;
}

startYScale = image_yscale;
doorOpener = new Fractional(doorOpenSpeed);
isOpen = false;

boundsLeft = bbox_left + 3;
boundsTop = bbox_top + 3;
boundRight = bbox_right - 3;
boundBottom = bbox_bottom - 3;

__canOpen = false;
__isInsideView = false;