class_name JuicerBounceEffect
extends JuicerEffect

@export_group("Bounce Settings")
@export var bounce_offset: Vector2 = Vector2(0, -8.0)
@export var duration: float = 0.6

@export_group("Easing")
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_up: Tween.EaseType = Tween.EASE_OUT
@export var ease_down: Tween.EaseType = Tween.EASE_IN


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	var half_duration: float = duration * 0.5
	var position_property := "position"
	
	if can_use_offset(target):
		position_property = "offset_position"
	
	tween.tween_property(target, position_property, bounce_offset, half_duration)\
		.as_relative()\
		.set_trans(trans_type)\
		.set_ease(ease_up)
	
	tween.tween_property(target, position_property, -bounce_offset, half_duration)\
		.as_relative()\
		.set_trans(trans_type)\
		.set_ease(ease_down)
