/// @description Perform Interval Action
if (!inside_view() || !instance_exists(prtPlayer))
    exit;

var _canSpawnMole = false,
    _moleIndex = 0;

// Look for an empty slot in our mole list
var i = 0;
repeat(maxMoles) {
    if (!instance_exists(moles[i])) {
        moles[i] = noone;
        moleX[i] = -1;
        
        if (!_canSpawnMole) {
            _moleIndex = i;
            _canSpawnMole = true;
        }
    }
    
    i++;
}

if (!_canSpawnMole)
    exit;

var _moleX = 0,
    _moleY = game_view().center_y() - (112 - irandom(6)) * spawnYDir;

var _attempts = 0;
do {
    _moleX = prtPlayer.x + choose(1, -1) * irandom_range(20, 64);
    _moleX = round_to(_moleX, 8);
    _attempts++;
} until(!array_contains(moleX, _moleX) || _attempts > 64);

var _mole = spawn_entity(_moleX, _moleY, depth, objMole, { image_yscale: spawnYDir });
_mole.respawn = false;
_mole.emitSparks = molesMakeSparks;

moles[_moleIndex] = _mole;
moleX[_moleIndex] = _mole.x;
spawnYDir *= -1;
