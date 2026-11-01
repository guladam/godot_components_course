@icon("stat_pool.svg")
class_name StatPool
extends Node
## A current amount associated with a Stat.
## It is a value that gameplay events change, kept between 0 and an optional maximum.
##
## Use it for anything that goes up and down during play: health, mana, XP.
## The maximum is a [Stat], looked up through [member stats] and [member max_stat_id],
## so [i]max health[/i] is a [Stat] (changed by modifiers) while [i]health[/i] is a pool
## (changed by damage and healing). Leave [member max_stat_id] empty for a pool without
## an upper limit, such as total XP.
##
## When the maximum rises, [member current] rises by the same amount. When it falls,
## [member current] is only clamped down to the new maximum.
##
## [codeblock]
## var health: StatPool = $Health
##
## health.change(-12)  # take damage
## health.change(5)    # heal
## health.depleted.connect(die)
## [/codeblock]

## Emitted when [member current] changes, with the value before and after.
signal changed(old_value: float, new_value: float)
## Emitted when [member current] reaches zero.
signal depleted

## The [StatContainer] that holds the max stat.
## Only required when [member max_stat_id] is set.
@export var stats: StatContainer
## Name of the [Stat] that defines this pool's maximum, for example [code]&"max_health"[/code].
## Leave empty for a pool with no upper limit.
@export var max_stat_id: StringName
## If enabled, the pool starts at its maximum; otherwise it starts at 0.
## Pools without a max stat always start at 0.
@export var start_full: bool = true

## The current amount. Read it freely, but change it through [method change] so that
## clamping and signals are handled.
var current: float = 0.0
# The Stat that defines the maximum. Null when the pool has no upper limit.
var _max_stat: Stat


# If a max stat is configured: waits for the StatContainer to build its stats (so the order
# of nodes in the scene tree doesn't matter), listens to the max stat and optionally starts full.
func _ready() -> void:
	if max_stat_id == &"":
		return
	
	if not stats.is_node_ready():
		await stats.ready
	
	_max_stat = stats.get_stat(max_stat_id)
	assert(_max_stat, "Unknown stat: %s" % max_stat_id)
	_max_stat.changed.connect(_on_max_changed)
	
	if start_full:
		current = _max_stat.get_value()

## Returns the current maximum, or [code]INF[/code] if the pool has no max stat.
func get_max() -> float:
	return _max_stat.get_value() if _max_stat else INF


## Adds [param amount] to [member current], clamped between 0 and [method get_max].
## Use a negative amount for damage or spending and a positive one for healing or gaining.
## Emits [signal changed] if the amount changed, and [signal depleted] if it reached zero.
func change(amount: float) -> void:
	_set_current(current + amount)

# When the max goes up, current goes up by the same amount.
# When the max goes down, current is only clamped (the `maxf` ignores negative differences).
func _on_max_changed(old_max: float, new_max: float) -> void:
	_set_current(current + maxf(new_max - old_max, 0.0))

# Single place where `current` is changed: clamps it to the limits, then emits the signals.
func _set_current(value: float) -> void:
	var old_value := current
	current = clampf(value, 0.0, get_max())
	
	if is_equal_approx(old_value, current):
		return
	
	changed.emit(old_value, current)
	
	if is_zero_approx(current):
		depleted.emit()
