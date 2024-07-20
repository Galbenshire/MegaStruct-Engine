spriteElements = layer_get_all_elements(spriteLayer);
array_filter_ext(spriteElements, function(_el, i) /*=>*/ {return layer_get_element_type(_el) == layerelementtype_sprite});
array_foreach(spriteElements, function(_el, i) /*=>*/ { layer_sprite_speed(_el, 0); });
spriteElementCount = array_length(spriteElements);

if (spriteElementCount <= 0) {
    show_debug_message("No sprite elements could be found for objSpriteLayerAnimator");
    instance_destroy();
    exit;
}

animTimer = 0;
animIndex = 0;
spriteTypes = [];
spriteFrames = [];
spriteTypeCount = 0;

// Function - call this in Creation Code to add a sprite element for this animator to animate
// e.g addSpriteType(sprMM2Conveyor, [0, 1, 2, 3]);
function addSpriteType(_sprite, _imgIndexes) {
    array_push(spriteTypes, _sprite);
    array_push(spriteFrames, array_create(totalFrames));
    
    var _imgIndexCount = array_length(_imgIndexes);
    for (var i = 0; i < _imgIndexCount; i++)
        spriteFrames[spriteTypeCount][i] = _imgIndexes[i];
    
    spriteTypeCount++;
}