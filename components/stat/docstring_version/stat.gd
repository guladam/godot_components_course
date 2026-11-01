class_name Stat
extends RefCounted
## A single computed stat value, such as strength or max health.
##
## A [Stat] combines the base value from its [StatDefinition] with any number of
## [StatModifier]s and caches the result. The value can't be set directly: it only
## changes when modifiers are added or removed, and [signal changed] is emitted when it does.
##
## [b]Formula:[/b] [code](base + sum of flat) * (1 + sum of percent)[/code], clamped by the
## definition's limits. An [code]OVERRIDE[/code] modifier skips the formula and sets the
## (still clamped) value outright. See [enum StatModifier.Type].
##
## [codeblock]
## var strength := Stat.new(strength_definition) # base value 10
## strength.add_modifier(StatModifier.flat(&"belt", 2.0))
## strength.add_modifier(StatModifier.percent(&"potion", 0.25))
## print(strength.get_value()) # (10 + 2) * 1.25 = 15
## strength.remove_modifiers_from(&"potion")
## print(strength.get_value()) # 12
## [/codeblock]

## Emitted when the final value changes, with the value before and after.
## Not emitted when a modifier change leaves the value the same.
signal changed(old_value: float, new_value: float)

## The shared template this stat is built from.
## Read-only by convention: definitions are Resources shared between characters,
## so never write to it at runtime. Use modifiers instead.
var definition: StatDefinition
# Active modifiers, in the order they were added.
var _modifiers: Array[StatModifier] = []
# Cached final value, kept up to date by _refresh().
var _value: float

# Builds the stat from its definition and computes the initial value (no modifiers yet).
func _init(p_definition: StatDefinition) -> void:
	definition = p_definition
	_value = _calculate()

## Returns the current final value (base + modifiers, clamped by the definition).
## The value is cached, so this is cheap to call every frame.
func get_value() -> float:
	return _value

## Adds [param modifier] and recalculates the value.
## If the modifier is not stackable (see [member StatModifier.stackable]), existing
## modifiers from the same source are removed from this stat first.
## [signal changed] is emitted if the final value changes.
func add_modifier(modifier: StatModifier) -> void:
	if not modifier.stackable:
		_remove_from_source(modifier.source)
	
	_modifiers.append(modifier)
	_refresh()

## Removes every modifier on this stat that came from [param source] and recalculates.
## Does nothing if the source has no modifiers here.
func remove_modifiers_from(source: StringName) -> void:
	_remove_from_source(source)
	_refresh()

# Removes ALL modifiers from the [member _modifiers] Array identified by [param source].
func _remove_from_source(source: StringName) -> void:
	_modifiers.assign(_modifiers.filter(func(m: StatModifier): return m.source != source))

# Final value = (base + flat) * percent, clamped by the definition.
# `percent` starts at 1.0, so a +25% modifier (value 0.25) gives a 1.25 multiplier.
# An OVERRIDE modifier ends the calculation early: the first one found wins.
func _calculate() -> float:
	var flat := 0.0
	var percent := 1.0
	
	for modifier in _modifiers:
		match modifier.type:
			StatModifier.Type.FLAT:
				flat += modifier.value
			StatModifier.Type.PERCENT_BASED:
				percent += modifier.value
			StatModifier.Type.OVERRIDE:
				return definition.clamp_value(modifier.value)
	
	return definition.clamp_value((definition.base_value + flat) * (percent))

# Recalculates the cached value and emits `changed` only if it actually changed.
func _refresh() -> void:
	var old_value := _value
	_value = _calculate()

	if not is_equal_approx(old_value, _value):
		changed.emit(old_value, _value)
