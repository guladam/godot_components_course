@abstract
class_name JuicerEffect
extends Resource
## Base class for procedural target effects.

## Override this method in child resources to append property steps to the tween.
@abstract func apply_to_tween(target: CanvasItem, tween: Tween) -> void
