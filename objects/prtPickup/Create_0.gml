event_inherited();

pickupID = string("{0}|{1}|{2}", room, xstart, ystart);
disappearTimer = -1;
flashThreshold = 60;
flashIndex = 0;

__collectPlayer = noone;
__collected = false;