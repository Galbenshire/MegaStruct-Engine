/// @description Update Display Submenu Options
// This is needed since the user can also update some of these options via the Function keys
for (var i = 0; i < displaySubmenuOptionCount; i++) {
    with (submenus[displaySubmenu].options[i])
        onUpdateLabel();
}