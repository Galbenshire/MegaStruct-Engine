/// @description Character Setup
global.characterList[CharacterType.PROTO] = new Character({
    id: CharacterType.PROTO,
    object: objProtoMan,
    name: "Proto Man",
    
    colours: [
        $0028DC,
        $BCBCBC,
        $000000,
        $A5E7FF,
        $000000,
        $FFFFFF
    ],
    
    loadout: [
        WeaponType.BUSTER_PROTO,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE
    ],
    
    onGetGunOffset: function(_player) {
		var _offset/*:Vector2*/ = [16, 6];
		if (_player.isClimbing)
			_offset[@Vector2.y] -= 2;
		return _offset;
    }
});