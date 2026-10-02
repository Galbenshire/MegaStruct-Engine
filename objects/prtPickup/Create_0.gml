event_inherited();

#region Variables

iFrameFlashStyle = IFrameFlashType.FLICKER;

pickupID = string("{0}|{1}|{2}", room, xstart, ystart);
disappearTimer = -1;
flashThreshold = 60;

palette = copyPlayerPalette
	? new ColourPalette([ $EC7000, $F8B838, $000000, $ADE7FF, $FFFFFF ])
	: undefined;
playerPaletteListener = undefined;

collectingPlayer = noone;
isCollected = false;

#endregion

#region Callbacks

onSpawn = function() {
    cbkOnSpawn_base();
    
    if (copyPlayerPalette) {
		playerPaletteListener = signal_bus().connect_to_signal(SIGNAL_PLAYER_PALETTE_UPDATE, self, function(_data) {
			if (_data.player.playerID == 0)
				event_user(1);
		});
		event_user(1);
    }
};
onDespawn = function() {
    cbkOnDespawn_base();
    event_perform(ev_cleanup, 0);
};
onDeath = method(id, cbkOnDeath_projectile);
onDraw = function() {
	if (copyPlayerPalette)
		cbkOnDraw_colour_replacer();
	else
		cbkOnDraw_base();
};

#endregion