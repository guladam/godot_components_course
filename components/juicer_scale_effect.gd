class_name JuicerScaleEffect
extends JuicerEffect
## Animates target scale relative to its current scale.

@export var scale_amount: Vector2 = Vector2(1.2, 0.8)
@export var duration: float = 0.15
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type: Tween.EaseType = Tween.EASE_OUT


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	var scale_property := "scale"
	
	if can_use_offset(target):
		scale_property = "offset_transform_scale"
	
	tween.set_trans(trans_type).set_ease(ease_type)
	tween.tween_property(target, scale_property, scale_amount, duration)
