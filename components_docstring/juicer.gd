@icon("juicer.svg")
class_name Juicer
extends Node
## Drives data-driven 2D and UI animations using [JuicerEffectGroup] resources.
##
## Acts as a central execution manager for procedural visual effects ("juice"). 
## Delegates animation playback to dynamic resource configurations.

## Emitted when a non-looping [JuicerEffectGroup] animation completes execution.
signal group_tween_finished(group_name: StringName)

## The target [CanvasItem] ([Control] or [Node2D]) to apply visual animations onto.
## Defaults automatically to the parent node if left unassigned.
@export var target: CanvasItem

## The list of executable [JuicerEffectGroup] animation presets assigned to this component.
@export var effect_groups: Array[JuicerEffectGroup] = []

var _active_tween: Tween


func _ready() -> void:
	if not target and get_parent() is CanvasItem:
		target = get_parent() as CanvasItem


## Plays an [JuicerEffectGroup] animation sequence by its [StringName] identifier.
## [br][br]
## If [param loop] is set to [code]true[/code], the tween repeats indefinitely 
## until [method stop] is invoked.
func play(group_name: StringName, loop: bool = false) -> void:
	if not target:
		push_error("Juicer: Target node is not assigned.")
		return

	var group := _find_group(group_name)
	if not group:
		push_warning("Juicer: EffectGroup '%s' not found." % group_name)
		return

	if group.empty():
		push_warning("Juicer: EffectGroup '%s' has no valid Effects." % group_name)
		return

	stop()

	_active_tween = create_tween()
	if loop:
		_active_tween.set_loops()

	if group.parallel:
		_active_tween.set_parallel(true)

	for effect in group.effects:
		if effect:
			effect.apply_to_tween(target, _active_tween)

	_active_tween.finished.connect(
		func() -> void: group_tween_finished.emit(group_name),
		CONNECT_ONE_SHOT
	)


## Stops all currently running animation tweens immediately without emitting signals.
func stop() -> void:
	if _active_tween and _active_tween.is_running():
		_active_tween.kill()


func _find_group(group_name: StringName) -> JuicerEffectGroup:
	for group in effect_groups:
		if group and group.identifier == group_name:
			return group
	
	return null
