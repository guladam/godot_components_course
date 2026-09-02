@abstract
class_name JuicerEffect
extends Resource

@export var control_offset: bool = false

@abstract func apply_to_tween(target: CanvasItem, tween: Tween) -> void


func can_use_offset(target: CanvasItem) -> bool:
	return target is Control and control_offset and (target as Control).offset_transform_enabled
