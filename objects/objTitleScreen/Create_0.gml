options = [
    ["START GAME (CUT MAN)", function() /*=>*/ { go_to_level(lvlCutMan); }],
    ["START GAME (TEST ROOM)", function() /*=>*/ { go_to_level(lvlSections); }],
    ["OPTIONS", function() /*=>*/ { go_to_room(rmOptions); }]
];
optionCount = array_length(options);
currentOption = optionCount - 1;

play_sfx(sfxImportantItem);
array_reverse_ext(options);