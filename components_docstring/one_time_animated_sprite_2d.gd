@icon("one_time_animated_sprite_2d.svg")
class_name OneTimeAnimatedSprite2D
extends AnimatedSprite2D
## An [AnimatedSprite2D] that automatically queues a node for deletion when its animation finishes.
##
## This component is ideal for "fire-and-forget" visual elements such as 
## explosion effects, impact sparks, or dust particles for jumping.

## The target [Node] that should be freed from memory when the animation finishes playing.
## [br][br]
## Defaults to [code]self[/code] to clear just the sprite, but can be targeted to a parent 
## scene root to clean up an entire complex effect hierarchy.
@export var node_to_delete: Node = self


func _ready() -> void:
	animation_finished.connect(
		node_to_delete.queue_free,
		CONNECT_ONE_SHOT
	)
