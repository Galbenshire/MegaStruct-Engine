/// @func DamageSource(attacker_hitbox, subject_hitbox, damage)
/// @desc Represents an attack
///
/// @param {prtHitbox|prtEntity}  attacker_hitbox  The hitbox of the attacker in this attack
/// @param {prtHitbox|prtEntity}  subject_hitbox  The hitbox of the subject in this attack
/// @param {number}  damage  Initial strength of the damage
function DamageSource(_attackerHitbox, _subjectHitbox, _damage) constructor {
	#region Variables
	
	damageEnabled = false;
	blockEnabled = false;
	
    attacker = noone; /// @is {prtEntity}
    attackerHitbox = noone; /// @is {prtHitbox|prtEntity}
    
    subject = noone; /// @is {prtEntity}
    subjectHitbox = noone; /// @is {prtHitbox|prtEntity}
    
    damage = 0;
    displayDamage = undefined; // This will be shown to the player if Damage Popups are enabled
    
    attackDelay = 0; /// @is {int} Minimum interval in which this attack can damage the subject
    penetrates = false; /// @is {bool} Whether this attack can bypass the subject's block (true) or not (false)
    pierces = PierceType.ALWAYS; /// @is {int} Sets if the attacker should be destroyed after this attack
    blockType = BlockType.REFLECT; /// @is {int} If blocking, the type of block the subject is performing
    damageFlags = 0; /// @is {int} Additional infomation about the attack (use the DamageFlags enum here)
    
    hasKilled = false; /// @is {bool} Flags if this attack managed to kill its target
    hitSFX = sfxEnemyHit;
    
    #endregion
    
    #region Functions - Getters
    
    /// @method get_display_damage()
	/// @desc Gets the damage of this attack, as it would be shown in a damage popup
	///
	/// @returns {string}  The display damage
    static get_display_damage = function() {
		if (!is_undefined(displayDamage))
			return displayDamage;
		
		var _damageStr = string_format(damage, 1, 2 * (damage - floor(damage) > 0));
		
		// If the display ends up as something like "0.50", adjust it so it's "0.5"
		if (string_contains(".", _damageStr) && string_ends_with(_damageStr, "0"))
			_damageStr = string_delete(_damageStr, string_length(_damageStr), 1);
		
		return _damageStr;
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// @method set_attacker(attacker)
	/// @desc Sets the attacker of this attack; the one who's dealing damage
	///
	/// @param {prtHitbox|prtEntity}  attacker  The attacker, or its hitbox
	///
	/// @returns {DamageSource}  A reference to this struct. Useful for method chaining.
    static set_attacker = function(_attacker) {
		attackerHitbox = _attacker;
		attacker = is_object_type(prtHitbox, _attacker) ? _attacker.owner : _attacker;
		return self;
    };
    
    /// @method set_damage(value)
	/// @desc Sets the damage of this attack
	///
	/// @param {number}  value  The damage value
	///
	/// @returns {DamageSource}  A reference to this struct. Useful for method chaining.
    static set_damage = function(_value/*:number*/) {
        damage = _value;
		return self;
    };
    
    /// @method set_display_damage(value)
	/// @desc Sets the damage shown to the player if Damage Popups are enabled
	///
	/// @param {number}  value  The display value
	///
	/// @returns {DamageSource}  A reference to this struct. Useful for method chaining.
    static set_display_damage = function(_value/*:number*/) {
        displayDamage = _value;
		return self;
    };
    
    /// @method set_subject(subject)
	/// @desc Sets the subject of this attack; the one who should receive the damage
	///
	/// @param {prtHitbox|prtEntity}  subject  The subject, or its hitbox
	///
	/// @returns {DamageSource}  A reference to this struct. Useful for method chaining.
    static set_subject = function(_subject) {
		subjectHitbox = _subject;
		subject = is_object_type(prtHitbox, _subject) ? _subject.owner : _subject;
		return self;
    };
    
    #endregion
    
    #region Functions - Damage Flags
    
    /// @method add_flag(flag)
	/// @desc Adds a flag to the attack, corresponding to a bit from the DamageFlags enum
	///
	/// @param {int}  flag  The flag to add
    static add_flag = function(_flag) {
		damageFlags = bitmask_set_bit(damageFlags, _flag);
    };
    
    /// @method has_flag(flag)
	/// @desc Checks if the attack has a specific flag set on it
	///
	/// @param {int}  flag  The flag to check for (use the DamageFlags enum here)
	///
	/// @returns {bool}  If the flag is present on the attack (true) or not (false)
    static has_flag = function(_flag) {
		return bitmask_has_bit(damageFlags, _flag);
    };
    
    /// @method remove_flag(flag)
	/// @desc Removes a flag from this attack
	///
	/// @param {int}  flag  The flag to remove (use the DamageFlags enum here)
    static remove_flag = function(_flag) {
		damageFlags = bitmask_unset_bit(damageFlags, _flag);
    };
    
    #endregion
    
    #region Functions - Boolean Checks
    
    /// @method can_drop_item()
    /// @desc Checks if this attack is able to cause an item drop
    ///
	/// @returns {bool}  If items can be dropped (true) or not (false)
    static can_drop_item = function() {
		return !self.has_flag(DamageFlags.NO_RANDOM_ITEMDROP) || subject.itemDrop.dropType != ItemDropType.RANDOM;	
    };
    
    /// @method is_self_damage()
    /// @desc Checks if this attack's attacker & subject are the same entity (i.e. self damage)
    ///
	/// @returns {bool}  If this is self-damage (true) or not (false)
    static is_self_damage = function() {
		return attacker.id == subject.id;	
    };
    #endregion
    
    #region Functions - Other
    
    /// @method apply_damage()
    /// @desc Applies the damage of this attack to the subject
    static apply_damage = function() {
		var _mockDamage = self.has_flag(DamageFlags.MOCK_DAMAGE);
		
		subject.healthpoints -= damage * !_mockDamage;
		subject.onHurt(self);
		
		if (subject.healthpoints <= 0 && !_mockDamage) {
			hasKilled = true;
			subject.__isKilled = true;
			subject.onDeath(self);
		}
		
		subject.lastHitBy = attacker;
		subject.hitTimer = 0;
		
		if (!self.has_flag(DamageFlags.NO_POPUP) && options_data().damagePopup) {
			var _popupX = bbox_x_center(subject),
				_popupY = subject.bbox_top + 4;
			spawn_damage_popup(_popupX, _popupY, self.get_display_damage());
		}
    };
    
    /// @method process_attack()
    /// @desc Standard procedure for handling a collision between the attacker & the subject
    static process_attack = function() {
		damageEnabled = bitmask_has_bit(subjectHitbox.hitmask, HitMask.TAKE_DAMAGE) && bitmask_has_bit(subject.hitmaskMaster, HitMask.TAKE_DAMAGE);
		blockEnabled = bitmask_has_bit(subjectHitbox.hitmask, HitMask.BLOCK) && bitmask_has_bit(subject.hitmaskMaster, HitMask.BLOCK);
			
		var _canCollide = (damageEnabled || blockEnabled)
			&& !self.is_self_damage()
			&& bitmask_has_bit(attacker.factionMask, subject.factionLayer)
			&& !array_contains(attacker.hitIgnoreList, subject)
		if (!_canCollide)
			return;
		
		attacker.onAttackBegin(self);
		subject.onSetDamage(self);
		
		var _canBlock = blockEnabled || damage == 0;
		if (_canBlock) {
			subject.onHandleBlock(self);
			if (blockType != BlockType.NONE) {
				subject.onBlocking(self);
				attacker.onBlocked(self);
				return;
			}
		}
		
		var _canDamage = damageEnabled
			&& subject.hitTimer >= attackDelay
			&& !entity_is_dead(subject)
			&& (self.has_flag(DamageFlags.IGNORE_IFRAMES) || subject.iFrames == 0);
		if (_canDamage) {
			attacker.onAttack(self);
			if (damageEnabled) {
				self.apply_damage();
				attacker.onAttackEnd(self);
			}
			
			if (pierces == PierceType.NEVER || (pierces == PierceType.ON_KILLS_ONLY && !hasKilled))
				entity_kill_self(attacker);
		}
    };
    
    /// @method refresh_state(damage)
    /// @desc Refreshes some of the variables in this attack
    ///
	/// @param {number}  value  The damage value to reset to
    static refresh_state = function(_damage) {
		damageEnabled = false;
		blockEnabled = false;
		
		attackDelay = attacker.attackDelay;
		penetrates = attacker.penetrates;
		pierces = attacker.pierces;
		blockType = subject.blockType;
		damageFlags = 0;
		
		hasKilled = false;
		hitSFX = sfxEnemyHit;
		
		displayDamage = undefined;
		self.set_damage(_damage);
    };
    
    #endregion
    
    #region Init
    
    self.set_attacker(_attackerHitbox);
    self.set_subject(_subjectHitbox);
    self.refresh_state(_damage);
    
    #endregion
}
