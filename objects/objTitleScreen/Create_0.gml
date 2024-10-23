characters = array_create_ext(CharacterType.COUNT, function(i) /*=>*/ {return character_create_from_id(i)});
characterIndex = global.player.characterID;

options = [
    ["CUT MAN STAGE", function() /*=>*/ { go_to_level(lvlCutMan); }],
    ["METAL MAN STAGE", function() /*=>*/ { go_to_level(lvlMetalMan); }],
	["GEMINI MAN STAGE", function() /*=>*/ { go_to_level(lvlGeminiMan); }],
    ["TEST ROOM", function() /*=>*/ { go_to_level(lvlSections); }],
    [string("CHARACTER: {0}", characters[characterIndex].name), function () {
		characterIndex = modf(characterIndex + 1, CharacterType.COUNT);
        global.player.characterID = characterIndex;
        options[1][0] = string("CHARACTER: {0}", characters[characterIndex].name);
        play_sfx(sfxMenuMove);
    }],
    ["OPTIONS", function() /*=>*/ { go_to_room(rmOptions); }]
];
optionCount = array_length(options);
currentOption = optionCount - 1;

buildDate = date_date_string(GM_build_date);

play_music(MusicAsset.MM5_TITLE_SCREEN);
array_reverse_ext(options);