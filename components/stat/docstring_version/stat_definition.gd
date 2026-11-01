class_name StatDefinition
extends Resource
## Template data for a single stat: its name, base value and optional limits.
##
## This is a Resource that many characters can share (for example one
## [code].tres[/code] per enemy type), so treat it as read-only at runtime.
## Changes to a stat's value should go through [StatModifier]s on the [Stat] instead.
## Definitions are collected in a [StatSheet].

## Unique identifier used to look the stat up, for example [code]&"max_health"[/code].
@export var name: StringName
## The starting value, before any modifiers are applied.
@export var base_value: float = 100.0
## If enabled, the stat's final value can't go below [member min_limit].
@export var has_min_limit: bool = false
## The lowest value the stat can have. Only used when [member has_min_limit] is enabled.
@export var min_limit: float = 0.0
## If enabled, the stat's final value can't go above [member max_limit].
@export var has_max_limit: bool = false
## The highest value the stat can have. Only used when [member has_max_limit] is enabled.
@export var max_limit: float = 100.0

## Returns [param value] limited to this definition's range.
## Only the limits that are enabled are applied; with neither enabled the value is returned as is.
func clamp_value(value: float) -> float:
	if has_min_limit:
		value = maxf(value, min_limit)
	if has_max_limit:
		value = minf(value, max_limit)
	return value
