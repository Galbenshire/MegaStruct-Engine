illegalKeys = [
    vk_f1,
    vk_f2,
    vk_f3,
    vk_f4,
    vk_f5,
    vk_f6,
    vk_f7,
    vk_f8,
    vk_f9,
    vk_f10,
    vk_f11,
    vk_f12,
    vk_delete,
    vk_escape,
    vk_printscreen,
    vk_alt,
    vk_nokey,
    vk_anykey
];

inputNames = array_create(InputActions.COUNT);
inputNames[InputActions.LEFT] = "LEFT";
inputNames[InputActions.RIGHT] = "RIGHT";
inputNames[InputActions.UP] = "UP";
inputNames[InputActions.DOWN] = "DOWN";
inputNames[InputActions.JUMP] = "JUMP";
inputNames[InputActions.SHOOT] = "SHOOT";
inputNames[InputActions.SLIDE] = "SLIDE";
inputNames[InputActions.WEAPON_SWITCH_LEFT] = "WEAPON SWITCH (LEFT)";
inputNames[InputActions.WEAPON_SWITCH_RIGHT] = "WEAPON SWITCH (RIGHT)";
inputNames[InputActions.PAUSE] = "PAUSE";

inputIndex = 0;

keysUsed = [];

errorMessage = "";
errorTimer = 0;

controllerID = objSystem.input.reader.controller;