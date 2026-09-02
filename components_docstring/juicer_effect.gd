@abstract
class_name JuicerEffect
extends Resource
## Abstract base resource representing an isolated procedural transformation step.
##
## All custom visual effect resources must extend this class and override 
## [method apply_to_tween] to append property transitions onto an active engine [Tween].

## When [code]true[/code], target offset properties are preferred over raw transforms 
## for supported [Control] elements.
@export var control_offset: bool = false

## Virtual method called by [Juicer] to append transformation steps onto the given [param tween].
@abstract func apply_to_tween(target: CanvasItem, tween: Tween) -> void


## Evaluates whether the target element is a valid [Control] node capable of offset transforms.
func can_use_offset(target: CanvasItem) -> bool:
	return target is Control and control_offset and (target as Control).offset_transform_enabled
