/// @description Update Sprite Elements
var i = 0;
repeat(spriteElementCount) {
    var _spriteType = array_get_index(spriteTypes, layer_sprite_get_sprite(spriteElements[i]));
    if (_spriteType == NOT_FOUND)
        continue;
    
    var _imgIndex = spriteFrames[_spriteType][animIndex];
    layer_sprite_index(spriteElements[i], _imgIndex);
    
    i++;
}
