// These are base callbacks for `onPreDraw`
// This callback gets called just before an entity is about to be drawn.
//
// This callback will set up any visual effects that should be applied to the entity.
// This includes i-frames effects & being frozen.
// It can also skip the rendering for the entity, depending on the situation.
//
// `onPreDraw` will get called as part of `entity_draw`, which by default, will be called in an entity's Draw Event.
// This callback should only be called in that context, as it can lead to unintended behaviour oherwise.
// For that reason, overriding this callback is not recommended unless you know what you're doing.

/// @func cbkOnPreDraw_base()
/// @desc Default onPreDraw callback for all entities
///
/// @returns {bool}  If the entity should be rendered (true) or not (false)
function cbkOnPreDraw_base() {
    gpu_push_state();
    
    // Handle i-Frames
    var _iFrameCounter = (iFrames >> 1) & 3;
    switch (iFrameFlashStyle) {
        case IFrameFlashType.WHITEFLASH:
            if (_iFrameCounter & 1)
                return false;
            if (_iFrameCounter) {
                gpu_set_fog(true, c_white, 0, 0);
                return true;
            }
            break;
        case IFrameFlashType.HITSPARK:
            if (_iFrameCounter >= 2) {
                draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), 1, 1, 0, c_white, 1);
                return false;
            }
            break;
        case IFrameFlashType.FLICKER:
            if (_iFrameCounter >= 2)
                return false;
            break;
    }
    
    if (entity_appears_frozen() && frozenColour >= 0) // Appear Frozen?
        gpu_set_fog(true, frozenColour, 0, 0);
    
    return true;
}
