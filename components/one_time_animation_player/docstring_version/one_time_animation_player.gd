@icon("one_time_animation_player.svg")
class_name OneTimeAnimationPlayer
extends AnimationPlayer
## An [AnimationPlayer] that automatically queues a node for deletion when an animation finishes.
##
## This component acts as a "fire-and-forget" lifecycle manager for complex visual 
## effects.

## The target [Node] that should be freed from memory when the animation finishes playing.
## [br][br]
## Defaults to [code]self[/code] to clear just the player, but is typically targeted 
## to a parent scene root to clean up an entire complex VFX asset structure.
@export var node_to_delete: Node = self


func _ready() -> void:
	animation_finished.connect(
		node_to_delete.queue_free.unbind(1), 
		CONNECT_ONE_SHOT
	)
