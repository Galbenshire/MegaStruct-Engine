/// @func DamageSource(attacker, subject)
/// @desc Represents an attack
///
/// @param {prtEntity}  attacker  The entity performing the attack
/// @param {prtEntity}  subject  The entity the attacker is attacking
/// @param {number}  damage  Initial strength of the damage
function DamageSource(_attacker/*:prtEntity*/, _subject/*:prtEntity*/, _damage/*: number*/) constructor {
    attacker = _attacker; /// @is {prtEntity}
    subject = _subject; /// @is {prtEntity}
    
    damage = _damage; /// @is {number}
    displayDamage = string(_damage); /// @is {string} This will be shown to the player if Damage Popups are enabled
    
    damageFlags = 0; /// Addition infomation about the attack (use the DamageFlags enum here)
    guard = GuardType.DAMAGE; /// @is {number}
    hitSFX = sfxEnemyHit; /// @is {sound}
    
    hasKilled = false; /// @is {bool} Used to flag if this attack managed to kill its target
    
    /// @method add_flag(flag)
	/// @desc Adds a flag to the attack, corresponding to a bit from the DamageFlags enum
	///
	/// @param {number}  flag  The flag to add
    static add_flag = function(_flag) {
		damageFlags |= _flag;
    };
    
    /// @method has_flag(flag)
	/// @desc Checks if the attack has a specific flag set on it
	///
	/// @param {number}  flag  The flag to check for (use the DamageFlags enum here)
	///
	/// @returns {bool}  If the flag is present on the attack (true) or not (false)
    static has_flag = function(_flag) {
		return (_flag & damageFlags) > 0;	
    };
    
    /// @method remove_flag(flag)
	/// @desc Removes a flag from this attack
	///
	/// @param {number}  flag  The flag to remove (use the DamageFlags enum here)
    static remove_flag = function(_flag) {
		damageFlags &= ~_flag;
    };
    
    /// @method set_damage(value)
	/// @desc Sets the damage of this attack, as well as what will be displayed if Damage Popups are enabled
	///
	/// @param {number}  value  The damage value
    static set_damage = function(_value/*:number*/) {
        damage = _value;
        displayDamage = string(_value);
    };
}

/// @func DamageSourceSelf(subject)
/// @desc Represents self-damage
///
/// @param {prtEntity}  [subject]  The entity that is hurting itself. Defaults to whoever called the constructor
function DamageSourceSelf(_subject = other) : DamageSource(_subject, _subject, 0) constructor {}
