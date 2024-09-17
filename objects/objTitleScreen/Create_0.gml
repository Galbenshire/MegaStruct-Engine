options = [
    ["CUT MAN STAGE", function() /*=>*/ { go_to_level(lvlCutMan); }],
    ["METAL MAN STAGE", function() /*=>*/ { go_to_level(lvlMetalMan); }],
	["GEMINI MAN STAGE", function() /*=>*/ { go_to_level(lvlGeminiMan); }],
    ["TEST ROOM", function() /*=>*/ { go_to_level(lvlIce); }],
    [string("CHARACTER: {0}", global.player.get_character().name), function () {
        global.player.character = modf(global.player.character + 1, CharacterType.COUNT);
        options[1][0] = string("CHARACTER: {0}", global.player.get_character().name);
    }],
    ["OPTIONS", function() /*=>*/ { go_to_room(rmOptions); }]
];
optionCount = array_length(options);
currentOption = optionCount - 1;

buildDate = date_date_string(GM_build_date);

play_sfx(sfxImportantItem);
array_reverse_ext(options);