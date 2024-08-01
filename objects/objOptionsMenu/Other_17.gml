/// @description Storing this somewhere...
with (menu.add_submenu("controls")) {
    itemList = [];
    
    with (add_item("downjump")) {
        onXDir = function(__) /*=>*/ { options_data().downJumpSlide = !options_data().downJumpSlide; };
        
        label = "DOWN+JUMP";
        value = "";
        onUpdateValue = function() /*=>*/ {return options_data().downJumpSlide ? "SLIDE" : "NONE"};
        
        array_push(other.itemList, self);
    }
    with (add_item("autofire")) {
        onXDir = function(__) /*=>*/ { options_data().autoFire = !options_data().autoFire; };
        
        label = "AUTO FIRE";
        value = "";
        onUpdateValue = function() /*=>*/ {return options_data().autoFire ? "ON" : "OFF"};
        
        array_push(other.itemList, self);
    }
    with (add_item("chargetoggle")) {
        onXDir = function(__) /*=>*/ { options_data().chargeToggle = !options_data().chargeToggle; };
        
        label = "CHARGE TOGGLE";
        value = "";
        onUpdateValue = function() /*=>*/ {return options_data().chargeToggle ? "ON" : "OFF"};
        
        array_push(other.itemList, self);
    }
    
    currentItem = items.downjump;
}

menu.currentSubmenu = menu.submenus.controls;