/// @description Choose move speed
var _spd;
switch (burrowBitField) {
    case bitMask_FullyExposed:
        _spd = moveSpeed;
        break;
    
    case bitMask_TailExposed: // Head Buried
    case bitMask_HeadExposed: // Tail Buried
        _spd = digSpeed;
        break;
    
    case bitMask_FullyBuried: // Fully Buried
        _spd = __spawnedBurrowed ? spawnBurrowSpeed : burrowSpeed;
        break;
}

yspeed.value = _spd * image_yscale;