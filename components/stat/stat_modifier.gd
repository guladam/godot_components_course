class_name StatModifier
extends RefCounted

enum Type {PERCENT_BASED, FLAT, OVERRIDE}

@export var type: Type
@export var source: StringName
@export var value: float


static func percent(mod_source: StringName, amount: float) -> StatModifier:
	return StatModifier.new(mod_source, Type.PERCENT_BASED, amount)


static func flat(mod_source: StringName, amount: float) -> StatModifier:
	return StatModifier.new(mod_source, Type.FLAT, amount)
	

static func override(mod_source: StringName, amount: float) -> StatModifier:
	return StatModifier.new(mod_source, Type.OVERRIDE, amount)


func _init(p_source: StringName, p_type: Type, p_value: float) -> void:
	source = p_source
	type = p_type
	value = p_value


func _to_string() -> String:
	return "----Type: %s | Source: %s | Value: %s" % [
		Type.keys()[type],
		source,
		value
	]
