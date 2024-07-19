options = [
    ["CUT MAN STAGE", function() /*=>*/ { go_to_level(lvlCutMan); }],
    ["METAL MAN STAGE", function() /*=>*/ { go_to_level(lvlMetalMan); }],
    ["TEST ROOM", function() /*=>*/ { go_to_level(lvlSections); }],
    [string("CHARACTER: {0}", global.player.get_character().name), function () {
        global.player.character = (global.player.character != CharacterType.MEGA) ? CharacterType.MEGA : CharacterType.PROTO;
        options[1][0] = string("CHARACTER: {0}", global.player.get_character().name);
    }],
    ["OPTIONS", function() /*=>*/ { go_to_room(rmOptions); }]
];
optionCount = array_length(options);
currentOption = optionCount - 1;

play_sfx(sfxImportantItem);
array_reverse_ext(options);