/// @func DamageSource(attacker, attacker_hitbox, subject, subject_hitbox, damage)
/// @desc Represents an attack
///
/// @param {prtEntity}  attacker  The entity performing the attack
/// @param {prtHitbox|prtEntity}  attacker_hitbox  The hitbox of the attacker in this attack
/// @param {prtEntity}  subject  The entity the attacker is attacking
/// @param {prtHitbox|prtEntity}  subject_hitbox  The hitbox of the subject in this attack
/// @param {number}  damage  Initial strength of the damage
function DamageSource(_attacker, _attackerHitbox, _subject, _subjectHitbox, _damage) constructor {
	#region Variables
	
    attacker = _attacker; /// @is {prtEntity}
    attackerHitbox = _attackerHitbox; /// @is {prtHitbox|prtEntity}
    
    subject = _subject; /// @is {prtEntity}
    subjectHitbox = _subjectHitbox; /// @is {prtHitbox|prtEntity}
    
    damage = _damage; /// @is {number}
    displayDamage = string(_damage); /// @is {string} This will be shown to the player if Damage Popups are enabled
    
    damageFlags = 0; /// Addition infomation about the attack (use the DamageFlags enum here)
    guard = GuardType.DAMAGE; /// @is {number}
    hitSFX = sfxEnemyHit; /// @is {sound}
    
    hasKilled = false; /// @is {bool} Used to flag if this attack managed to kill its target
    
    #endregion
    
    #region Functions - Damage Flags
    
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
    
    #endregion
    
    #region Functions - Other
    
    /// @method attack_is_reflected()
    static attack_is_reflected = function() {
		if (guard == GuardType.FORCE_REFLECT)
			return true;
		else if (guard == GuardType.REFLECT || guard == GuardType.REFLECT_OR_IGNORE)
			return (attacker.penetrate == PenetrateType.NONE);
		else
			return false;
    };
    
    /// @method attack_is_guarded()
    static attack_is_guarded = function() {
		if (guard == GuardType.DAMAGE)
			return false;
		else if (guard == GuardType.REFLECT)
			return (attacker.penetrate != PenetrateType.BYPASS_GUARD);
		else
			return true;
    };
    
    /// @method calculate_damage()
	/// @desc Calculates how much damage this attack should do.
	///		  This is done by calling the subject's onSetDamage callback
    static calculate_damage = function() {
		subject.onSetDamage(self);
    };
    
    /// @method calculate_damage()
	/// @desc Calculates the guard state of this attack.
	///		  This is done by calling the subject's onGuard callback
    static calculate_guard = function() {
		subject.onGuard(self);
		if (damage == 0 && guard == GuardType.DAMAGE)
			guard = GuardType.FORCE_REFLECT;
    };
    
    /// @method set_damage(value)
	/// @desc Sets the damage of this attack, as well as what will be displayed if Damage Popups are enabled
	///
	/// @param {number}  value  The damage value
    static set_damage = function(_value/*:number*/) {
        damage = _value;
        displayDamage = string(_value);
    };
    
    #endregion
}

/// @func DamageSourceSelf(subject)
/// @desc Represents self-damage
///
/// @param {prtEntity}  [subject]  The entity that is hurting itself. Defaults to whoever called the constructor
function DamageSourceSelf(_subject = other) : DamageSource(_subject, _subject, _subject, _subject, 0) constructor {}
