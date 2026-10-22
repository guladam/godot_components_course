class_name Stat
extends RefCounted

signal changed(old_value: float, new_value: float)

var definition: StatDefinition
var _modifiers: Array[StatModifier] = []
var _value: float


func _init(p_definition: StatDefinition) -> void:
	definition = p_definition
	_value = _calculate()


func get_value() -> float:
	return _value


func add_modifier(modifier: StatModifier) -> void:
	_modifiers.append(modifier)
	_refresh()


func remove_modifiers_from(source: StringName) -> void:
	_modifiers.assign(_modifiers.filter(func(m: StatModifier): return m.source != source))
	_refresh()


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


func _refresh() -> void:
	var old_value := _value
	_value = _calculate()

	if not is_equal_approx(old_value, _value):
		changed.emit(old_value, _value)
