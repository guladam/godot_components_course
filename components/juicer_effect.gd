@abstract
class_name JuicerEffect
extends Resource
## Base class for procedural target effects.

## When true the offset properties will be tweened for Control targets.
@export var control_offset: bool = false

## Override this method in child resources to append property steps to the tween.
@abstract func apply_to_tween(target: CanvasItem, tween: Tween) -> void


func can_use_offset(target: CanvasItem) -> bool:
	return target is Control and control_offset and (target as Control).offset_transform_enabled
