@icon("juicer.svg")
class_name Juicer
extends Node
## Drives data-driven 2D and UI animations using [JuicerEffectGroup] resources.

signal group_tween_finished(group_name: StringName)

@export var target: CanvasItem
@export var effect_groups: Array[JuicerEffectGroup] = []

var _active_tween: Tween


## Plays an effect group by its StringName identifier.
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


## Stops all running tweens immediately.
func stop() -> void:
	if _active_tween and _active_tween.is_running():
		_active_tween.kill()


func _find_group(group_name: StringName) -> JuicerEffectGroup:
	for group in effect_groups:
		if group and group.identifier == group_name:
			return group
	
	return null
