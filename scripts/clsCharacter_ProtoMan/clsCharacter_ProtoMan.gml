function Character_ProtoMan() : Character() constructor {
    #region Static Data
	
	static id = CharacterType.PROTO;
	static name = "Proto Man";
	static object = objProtoMan;
	
	static colours = [
        $0028DC,
        $BCBCBC,
        $000000,
        $A5E7FF,
        $000000,
        $FFFFFF
    ];
    
	static loadout = [
        WeaponType.BUSTER_PROTO,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE,
        WeaponType.SEARCH_SNAKE
    ];
	
	#endregion
	
	#region Functions
	
	static get_gun_offset = function(_player) {
		var _offset/*:Vector2*/ = [10, 6];
		if (_player.isClimbing) {
			_offset[@Vector2.x] += 2;
			_offset[@Vector2.y] -= 2;
		} else if (!_player.ground) {
			_offset[@Vector2.x] -= 1;
		}
		return _offset;
	};
	
	#endregion
}