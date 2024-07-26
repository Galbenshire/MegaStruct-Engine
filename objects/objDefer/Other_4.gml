if (__placedInEditor)
    assert(false, "objDefer should not be placed in a room via the room editor. Please use defer()");

if (type == DeferType.ROOM_START)
    event_user(0);