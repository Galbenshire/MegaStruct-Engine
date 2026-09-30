/// @func ItemDrop(drop_type, drop_once, custom_drop)
/// @desc Represents an item to be dropped by an entity or explosion
///
/// @param {int}  drop_type  The type of item drop this is
/// @param {bool}  drop_once  Wheher this drop should only occur once (true) or not (false)
/// @param {object}  [custom_drop]  If the drop type is `CUSTOM`, this determines the object to drop. Optional otherwise.
function ItemDrop(_dropType, _dropOnce, _customDrop = noone) constructor {
    #region Variables
    
    owner = other.id;
    dropType = ItemDropType.RANDOM;
    item = noone;
    itemParams = {};
    dropOnce = _dropOnce;
    onItemDrop = undefined; /// @is {function<instance, void>?}
    
    __hasDropped = false;
    
    #endregion
    
    #region Functions
    
    /// @method random_item_table()
	/// @desc Used when drop type is set to `RANDOM`
    static random_item_table = function() {
        return weighted_random(global.randomDropTable, global.randomDropWeights);
    };
    
    /// @method set_custom_item_params(params)
	/// @desc Sets the pre-create parameters to apply to custom-spawned items
	///
	/// @param {struct}  params  The parameters to apply to the item when spawned
    static set_custom_item_params = function(_params) {
		if (dropType != ItemDropType.CUSTOM)
			print_err("set_custom_item_params is only usable when the drop type is set to CUSTOM");
		else
			itemParams =_params;
    }
    
    /// @method set_drop_type(type, custom_item)
	/// @desc Sets the drop type of this item drop
	///
	/// @param {int}  type  The type of item drop
	/// @param {object}  [custom_drop]  If the drop type is `CUSTOM`, this determines the object to drop. Optional otherwise.
    static set_drop_type = function(_type, _customItem = noone) {
        dropType = _type;
        onItemDrop = undefined;
        itemParams = {};
        
        switch (dropType) {
            case ItemDropType.NONE: item = noone; break;
            case ItemDropType.CUSTOM: item = _customItem; break;
            case ItemDropType.RANDOM:
                item = noone;
                onItemDrop = method(undefined, __onItemDrop_Random);
                break;
        }
    };
    
    /// @method set_on_custom_item_drop(func)
	/// @desc Sets the callback to run when the drop type is set to `CUSTOM`
	///
	/// @param {function<instance, void>}  func  The callback to execute
    static set_on_custom_item_drop = function(_func) {
		if (dropType != ItemDropType.CUSTOM)
			print_err("set_on_custom_item_drop is only usable when the drop type is set to CUSTOM");
		else
			onItemDrop = method(undefined, _func);
    };
    
    /// @method spawn_item(x, y, depth)
	/// @desc Spawns the item defined in this drop
	///
	/// @param {number}  x  x-position of the spawn
	/// @param {number}  y  y-position of the spawn
	/// @param {number}  depth  depth to spawn the item at
    static spawn_item = function(_x, _y, _depth) {
		if (dropOnce && __hasDropped)
			return noone;
		
		if (dropType == ItemDropType.RANDOM)
			item = self.random_item_table();
		if (item == noone)
			return;
		
		var _drop = (object_is_ancestor(item, prtEntity) || item == prtEntity)
			? spawn_entity(_x, _y, _depth, item, itemParams)
			: instance_create_depth(_x, _y, _depth, item, itemParams);
		_drop.x -= (bbox_x_center(_drop) - _drop.x);
		_drop.y -= (bbox_y_center(_drop) - _drop.y);
		
		if (!is_undefined(onItemDrop))
			onItemDrop(_drop);
		
		__hasDropped = true;
		return _drop;
    };
    
    #endregion
    
    #region Callback Presets
    
    /// @method __onItemDrop_Random(item)
	/// @desc The onItemDrop callback when the drop type is set to `RANDOM`
	///       This will make the spawned pickups disappear if not picked up
    static __onItemDrop_Random = function(_item) {
		_item.respawnType = RespawnType.DISABLED;
        _item.disappearTimer = 270;
        _item.yspeed = -2 * _item.gravDir;
    };
    
    #endregion
    
    #region Initialization
    
    self.set_drop_type(_dropType, _customDrop);
    
    #endregion
}