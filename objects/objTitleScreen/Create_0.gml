options = [
    ["START GAME", function() /*=>*/ { go_to_room(lvlCutMan); }],
    ["OPTIONS", function() /*=>*/ { go_to_room(rmOptions); }]
];
optionCount = array_length(options);
currentOption = optionCount - 1;

play_sfx(sfxImportantItem);
array_reverse_ext(options);