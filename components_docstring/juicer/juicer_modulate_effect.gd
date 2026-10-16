class_name JuicerModulateEffect
extends JuicerEffect
## Animates the color modulate property of a target.
##
## Designed to be stored inside a [JuicerEffectGroup] resource for flash, 
## fade-in, fade-out, or tint transitions.

## The target [Color] value to transition toward.
@export var color: Color = Color.TRANSPARENT

## Duration of the color transition in seconds.
@export var duration: float = 0.15

## Transition curve style for the color modulate tween.
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK

## Easing behavior curve for the color modulate tween.
@export var ease_type: Tween.EaseType = Tween.EASE_OUT


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	tween.set_trans(trans_type).set_ease(ease_type)
	tween.tween_property(target, "modulate", color, duration)
