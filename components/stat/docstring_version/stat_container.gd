@icon("stat_container.svg")
class_name StatContainer
extends Node
## Holds all of a character's [Stat]s and is the entry point for reading and modifying them.
##
## When the node becomes ready it builds one [Stat] per [StatDefinition] in [member sheet].
## Other code (UI, items, [StatPool]s) talks to the character's stats through this node.
## It does no calculation or clamping itself; that lives in [Stat] and [StatDefinition].
##
## [codeblock]
## var stats: StatContainer = $StatContainer
## stats.add_modifier(&"strength", StatModifier.flat(&"belt_of_giants", 2.0))
## print(stats.get_stat(&"strength").get_value())
## stats.remove_modifier(&"belt_of_giants") # undoes everything that source added
## [/codeblock]

## The stat sheet this character's stats are built from.
## Must be assigned before the node is ready.
@export var sheet: StatSheet

# Runtime stats keyed by their definition's name. Filled in _ready().
var _stats: Dictionary[StringName, Stat] = {}

# Creates one Stat per definition in the sheet.
func _ready() -> void:
	for definition: StatDefinition in sheet.stat_definitions:
		_stats[definition.name] = Stat.new(definition)

## Returns the [Stat] called [param stat_name], or [code]null[/code] if the sheet
## doesn't define one.
func get_stat(stat_name: StringName) -> Stat:
	return _stats.get(stat_name)

## Adds [param modifier] to the stat called [param stat_name].
## The stat must exist; an unknown name causes a runtime error.
func add_modifier(stat_name: StringName, modifier: StatModifier) -> void:
	_stats[stat_name].add_modifier(modifier)

## Removes every modifier that came from [param source], across all stats.
## Use it to undo a whole potion, relic or buff in one call, no matter how many
## stats it affected.
func remove_modifier(source: StringName) -> void:
	for stat: Stat in _stats.values():
		stat.remove_modifiers_from(source)
