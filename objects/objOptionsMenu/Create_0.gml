menu = new UIMenu();

with (menu.add_submenu("controls")) {
    itemList = [];
    
    for (var i = 0; i < 5; i++) {
        with (add_item($"item_{i}")) {
            label = $"Item {i}";
            onFocusEnter = function() /*=>*/ { print($"Enter Label: {label}", WarningLevel.SHOW); };
            onXDir = function(_xDir) /*=>*/ { print($"{label} | {_xDir}", WarningLevel.SHOW); };
            array_push(other.itemList, self);
        }
    }
    
    generate_neighbours_from_list(itemList, true);
    currentItem = itemList[0];
    array_at(itemList, -1).neighbourBottom = undefined;
}

with (menu.add_submenu("display")) {
    itemList = [];
    
    for (var i = 0; i < 4; i++) {
        with (add_item($"item_{i}")) {
            label = $"Other Item {i}";
            onFocusEnter = function() /*=>*/ { print($"Enter Label: {label}", WarningLevel.SHOW); };
            onTick = function(_inputs) {
                // if (_inputs.is_pressed(InputActions.JUMP))
                //     print($"{label} | Yump", WarningLevel.SHOW);
                // if (_inputs.is_pressed(InputActions.SHOOT))
                //     print($"{label} | Yhoot", WarningLevel.SHOW);
                if (global.roomTimer mod 60 == 0)
                    print($"{label} | Tick", WarningLevel.SHOW);
            };
            array_push(other.itemList, self);
        }
    }
    
    generate_neighbours_from_list(itemList, true);
    currentItem = itemList[0];
    array_at(itemList, -1).neighbourBottom = undefined;
}

with (menu.add_submenu("audio")) {
    itemList = [];
    
    for (var i = 0; i < 5; i++) {
        with (add_item($"item_{i}")) {
            label = $"#{i}";
            onYDir = function(_yDir) /*=>*/ { print($"Me ({label})", WarningLevel.SHOW); };
            array_push(other.itemList, self);
        }
    }
    
    generate_neighbours_from_list(itemList, false);
    currentItem = itemList[0];
}

menu.submenus.controls.neighbourRight = menu.submenus.display;
menu.submenus.controls.neighbourBottom = menu.submenus.audio;
menu.submenus.display.neighbourLeft = menu.submenus.controls;
menu.submenus.display.neighbourBottom = menu.submenus.audio;
menu.submenus.audio.neighbourTop = menu.submenus.controls;
menu.currentSubmenu = menu.submenus.controls;