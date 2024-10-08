// Only player entities actually controlled by a player can trigger touch checkpoints
if (!other.is_user_controlled())
    exit;

event_user(0);
instance_destroy();
