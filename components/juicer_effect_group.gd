class_name JuicerEffectGroup
extends Resource

@export var identifier: StringName = &"pop_in"
@export var parallel: bool = false
@export var effects: Array[JuicerEffect] = []


func empty() -> bool:
	var filtered_effects: Array[JuicerEffect] = effects.filter(
		func(effect: JuicerEffect) -> bool: 
			return effect != null
	)
	
	return filtered_effects.is_empty()
