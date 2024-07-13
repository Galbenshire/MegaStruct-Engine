// Only player entities actually controlled by a player can trigger touch checkpoints
if (!is_player_controlled(other))
    exit;

event_perform_object(objCheckpoint, ev_other, ev_user0);
instance_destroy();
