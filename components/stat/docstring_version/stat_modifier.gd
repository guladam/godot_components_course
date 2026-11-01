class_name StatModifier
extends RefCounted
## A single bonus, penalty or override applied to a [Stat], tagged with where it came from.
##
## Create modifiers with the factory methods [method flat], [method percent] and
## [method override]. The [member source] identifies the potion, relic or buff that
## added it, so everything it added can be removed again with
## [method StatContainer.remove_modifier].
##
## [codeblock]
## stats.add_modifier(&"max_health", StatModifier.flat(&"vigor_potion", 20.0))
## stats.add_modifier(&"strength", StatModifier.percent(&"rage", 0.5)) # +50%
## stats.add_modifier(&"speed", StatModifier.override(&"stun", 0.0))   # force to 0
## [/codeblock]

## How a modifier changes the stat it is applied to.
enum Type {
    ## Adds [member value] to the stat's multiplier, so [code]0.25[/code] means +25%.
	## All percent modifiers are summed first, then applied as one multiplier.    
    PERCENT_BASED,
   	## Adds [member value] to the base value, before the multiplier is applied.
    FLAT,
    ## Replaces the stat's result with [member value] (still clamped by the definition's
	## limits). Ignores the base value and all other modifiers.
    OVERRIDE
}

## What kind of change this modifier makes. See [enum Type].
var type: Type
## Identifier of whatever applied this modifier (a potion, relic, buff, level...).
## Used to remove modifiers again and to replace non-stackable ones.
var source: StringName
## The amount. Its meaning depends on [member type]: a flat amount, a percentage
## as a fraction (0.25 = 25%), or the final value for an override.
var value: float
## If [code]false[/code], adding this modifier to a [Stat] first removes any modifiers
## from the same [member source] on that stat, so only one can exist per source.
## If [code]true[/code], modifiers from the same source accumulate.
var stackable: bool = true

## Creates a percent modifier. [param amount] is a fraction: [code]0.25[/code] = +25%.
## [param mod_source] is where it comes from; [param stacking] is stored in [member stackable].
static func percent(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.PERCENT_BASED, amount, stacking)

## Creates a flat modifier that adds [param amount] to the stat's base value.
## [param mod_source] is where it comes from; [param stacking] is stored in [member stackable].
static func flat(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.FLAT, amount, stacking)
	
## Creates an override modifier that forces the stat to [param amount] (before clamping).
## [param mod_source] is where it comes from; [param stacking] is stored in [member stackable].
static func override(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.OVERRIDE, amount, stacking)

# Prefer the static factory methods above over calling StatModifier.new() directly.
func _init(p_source: StringName, p_type: Type, p_value: float, p_stackable: bool) -> void:
	source = p_source
	type = p_type
	value = p_value
	stackable = p_stackable

# Readable one-line description, handy for print() and debugging.
func _to_string() -> String:
	return "----Type: %s | Source: %s | Value: %s" % [
		Type.keys()[type],
		source,
		value
	]
