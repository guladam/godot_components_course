class_name StatModifier
extends RefCounted

enum Type {PERCENT_BASED, FLAT, OVERRIDE}

@export var type: Type
@export var source: StringName
@export var value: float
@export var stackable: bool = true


static func percent(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.PERCENT_BASED, amount, stacking)


static func flat(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.FLAT, amount, stacking)
	

static func override(mod_source: StringName, amount: float, stacking: bool = true) -> StatModifier:
	return StatModifier.new(mod_source, Type.OVERRIDE, amount, stacking)


func _init(p_source: StringName, p_type: Type, p_value: float, p_stackable: bool) -> void:
	source = p_source
	type = p_type
	value = p_value
	stackable = p_stackable


func _to_string() -> String:
	return "----Type: %s | Source: %s | Value: %s" % [
		Type.keys()[type],
		source,
		value
	]
