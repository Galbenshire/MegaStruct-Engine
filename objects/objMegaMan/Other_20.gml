/// @description Character Setup
global.characterList[CharacterType.MEGA] = new Character({
    id: WeaponType.BUSTER,
    object: objMegaMan,
    name: "Mega Man",
    
    colours: [
        $EC7000,
        $F8B838,
        $000000,
        $A8D8FC,
        $000000,
        $FFFFFF
    ],
    
    loadout: [
        WeaponType.BUSTER,
        WeaponType.ICE_SLASHER,
        WeaponType.METAL_BLADE
    ]
});
