// Only player entities actually controlled by a player can trigger touch checkpoints
if (!player_is_user_controlled(other) || !player_is_active(other))
    exit;

event_user(0);
instance_destroy();
