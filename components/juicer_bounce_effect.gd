class_name JuicerBounceEffect
extends JuicerEffect
## Animates a target's position up and down relative to its starting point.
##
## Designed to be stored in an [JuicerEffectGroup] resource. When played with looping 
## enabled on the [Juicer], this creates a continuous bobbing/floating motion.

@export_group("Bounce Settings")
## The directional offset of the bounce in pixels. 
## Default [code]Vector2(0, -8)[/code] floats upward by 8 pixels.
@export var bounce_offset: Vector2 = Vector2(0, -8.0)

## Total duration of one complete bounce cycle (up and back down) in seconds.
@export var duration: float = 0.6

@export_group("Easing")
## Transition curve used for both phases of the bounce.
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE

## Easing curve for the upward phase.
@export var ease_up: Tween.EaseType = Tween.EASE_OUT

## Easing curve for the downward phase.
@export var ease_down: Tween.EaseType = Tween.EASE_IN


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	var half_duration: float = duration * 0.5
	var position_property := "position"
	
	if can_use_offset(target):
		position_property = "offset_position"
	
	# Phase 1: Rise relative to current position
	tween.tween_property(target, position_property, bounce_offset, half_duration)\
		.as_relative()\
		.set_trans(trans_type)\
		.set_ease(ease_up)
		
	# Phase 2: Fall back down to original position
	tween.tween_property(target, position_property, -bounce_offset, half_duration)\
		.as_relative()\
		.set_trans(trans_type)\
		.set_ease(ease_down)
