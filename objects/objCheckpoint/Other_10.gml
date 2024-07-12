var _checkpoint = objSystem.level.checkpoint;

if (_checkpoint.room == room && _checkpoint.x == __x && _checkpoint.y == __y)
    exit;

_checkpoint.room = room;
_checkpoint.x = __x;
_checkpoint.y = __y;
_checkpoint.dir = __dir;

show_debug_message("--checkpoint--");
