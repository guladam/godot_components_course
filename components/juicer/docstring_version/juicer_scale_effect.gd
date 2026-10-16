class_name JuicerScaleEffect
extends JuicerEffect
## Procedural scaling effect supporting both relative juice squishes and absolute scale targets.
##
## Designed to be stored inside a [JuicerEffectGroup] resource preset.

## Target scale vector. Represents an absolute target when [member absolute] is [code]true[/code], 
## or a multiplicative scale factor when [member absolute] is [code]false[/code].
@export var scale_amount: Vector2 = Vector2(1.2, 0.8)

## Duration of the scaling transition in seconds.
@export var duration: float = 0.15

## When [code]true[/code], scales directly to [member scale_amount].
## When [code]false[/code], scales relative to the target's current scale factor.
@export var absolute: bool = false

## Transition curve style for the scaling tween.
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK

## Easing behavior curve for the scaling tween.
@export var ease_type: Tween.EaseType = Tween.EASE_OUT


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	var scale_property := "scale"
	
	if can_use_offset(target):
		scale_property = "offset_transform_scale"
	
	tween.set_trans(trans_type).set_ease(ease_type)
	
	if absolute:
		tween.tween_property(target, scale_property, scale_amount, duration)
	else:
		var current_scale: Vector2 = target.get(scale_property)
		tween.tween_property(target, scale_property, current_scale * scale_amount, duration)
