class_name JuicerModulateEffect
extends JuicerEffect
## Animates the target's modulate color.

@export var color: Color = Color.TRANSPARENT
@export var duration: float = 0.15
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type: Tween.EaseType = Tween.EASE_OUT


func apply_to_tween(target: CanvasItem, tween: Tween) -> void:
	tween.set_trans(trans_type).set_ease(ease_type)
	tween.tween_property(target, "modulate", color, duration)
