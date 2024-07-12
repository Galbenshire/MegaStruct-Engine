// Only player entities actually controlled by a player can trigger touch checkpoints
if (is_undefined(other.playerUser))
    exit;

event_perform_object(objCheckpoint, ev_other, ev_user0);
instance_destroy();
