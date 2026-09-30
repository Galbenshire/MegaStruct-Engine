// These are base callbacks for `onPostDraw`
// This callback gets called just after an entity has been drawn
//
// `onPostDraw` will reset any changes made by `onPreDraw`.
// It will also apply a frozen effect to the entity, if said entity is in that state.
//
// `onPostDraw` will get called as part of `entity_draw`, which by default, will be called in an entity's Draw Event.
// This callback should only be called in that context, as it can lead to unintended behaviour otherwise.
// For that reason, overriding this callback is not recommended unless you know what you're doing.


/// @func cbkOnPostDraw_base()
/// @desc Default onPostDraw callback for all entities
///
/// @returns {bool}  If the entity should be rendered (true) or not (false)
function cbkOnPostDraw_base() {
    gpu_pop_state();
    
    if (entity_appears_frozen()) {
        if (frozenColour >= 0) {
            gpu_set_blendmode(bm_add);
            onDraw();
            gpu_set_blendmode(bm_normal);
        }
    }
}