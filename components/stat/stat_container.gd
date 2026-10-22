@icon("stat_container.svg")
class_name StatContainer
extends Node

@export var sheet: StatSheet

var _stats: Dictionary[StringName, Stat] = {}


func _ready() -> void:
	for definition: StatDefinition in sheet.stat_definitions:
		_stats[definition.name] = Stat.new(definition)


func get_stat(stat_name: StringName) -> Stat:
	return _stats.get(stat_name)


func add_modifier(stat_name: StringName, modifier: StatModifier) -> void:
	_stats[stat_name].add_modifier(modifier)


func remove_modifier(source: StringName) -> void:
	for stat: Stat in _stats.values():
		stat.remove_modifiers_from(source)
