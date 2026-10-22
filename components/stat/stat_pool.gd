@icon("stat_pool.svg")
class_name StatPool
extends Node

signal changed(old_value: float, new_value: float)
signal depleted

@export var stats: StatContainer
@export var max_stat_id: StringName
@export var start_full: bool = true

var current: float = 0.0
var _max_stat: Stat


func _ready() -> void:
	if max_stat_id == &"":
		return
	
	if not stats.is_node_ready():
		await stats.ready
	
	_max_stat = stats.get_stat(max_stat_id)
	_max_stat.changed.connect(_on_max_changed)
	
	if start_full:
		current = _max_stat.get_value()


func get_max() -> float:
	return _max_stat.get_value() if _max_stat else INF


func change(amount: float) -> void:
	_set_current(current + amount)


func _on_max_changed(old_max: float, new_max: float) -> void:
	_set_current(current + maxf(new_max - old_max, 0.0))


func _set_current(value: float) -> void:
	var old_value := current
	current = clampf(value, 0.0, get_max())
	
	if is_equal_approx(old_value, current):
		return
	
	changed.emit(old_value, current)
	
	if is_zero_approx(current):
		depleted.emit()
