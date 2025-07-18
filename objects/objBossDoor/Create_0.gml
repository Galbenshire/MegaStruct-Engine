event_inherited();

transitions = instance_place_array(x, y, objScreenTransition, false);
transitionCount = array_length(transitions);

if (transitionCount <= 0) {
	print_err($"Boss Door ({x}, {y}) in an invalid location. Removing...");
    instance_destroy();
    exit;
}

startYScale = image_yscale;
doorOpener = new Fractional(doorOpenSpeed);
isOpen = false;

boundsLeft = bbox_left + 2;
boundsTop = bbox_top + 2;
boundRight = bbox_right - 2;
boundBottom = bbox_bottom - 2;

__canOpen = false;