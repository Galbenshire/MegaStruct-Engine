// Only player entities actually controlled by a player can trigger touch checkpoints
if (!is_player_controlled(other))
    exit;

event_user(0);
instance_destroy();
