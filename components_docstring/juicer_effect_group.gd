class_name JuicerEffectGroup
extends Resource
## A named collection container of [JuicerEffect] resources.
##
## Defines execution mode (parallel vs. sequential) and acts as an inspector 
## configuration animation chains.

## The unique identifier used by a [Juicer] component to trigger this animation group.
@export var identifier: StringName = &"pop_in"

## When [code]true[/code], all child [JuicerEffect] steps execute concurrently within the tween.
@export var parallel: bool = false

## The array of configured [JuicerEffect] resource instances in this group.
@export var effects: Array[JuicerEffect] = []


## Evaluates whether the group contains at least one valid, non-null [JuicerEffect] resource.
func empty() -> bool:
	var filtered_effects: Array[JuicerEffect] = effects.filter(
		func(effect: JuicerEffect) -> bool: 
			return effect != null
	)
	
	return filtered_effects.is_empty()
	
