class_name StatDefinition
extends Resource

@export var name: StringName
@export var base_value: float = 100.0
@export var has_min_limit: bool = false
@export var min_limit: float = 0.0
@export var has_max_limit: bool = false
@export var max_limit: float = 100.0


func clamp_value(value: float) -> float:
	if has_min_limit:
		value = maxf(value, min_limit)
	if has_max_limit:
		value = minf(value, max_limit)
	return value
