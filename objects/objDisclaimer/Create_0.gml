text = "MEGA MAN AND ALL RELATED CONTENT (C) CAPCOM 2024."
    + "\n\nTHIS GAME IS A NONPROFIT EFFORT BY FANS. IT IS NOT FOR SALE."
    + "\n\nMADE WITH THE MEGA STRUCT ENGINE.";

timer = time_source_create(time_source_global, 7, time_source_units_seconds, function() /*=>*/ { event_user(0); });

alarm[0] = 1;