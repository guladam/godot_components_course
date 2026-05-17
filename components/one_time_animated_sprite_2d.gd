@icon("one_time_animated_sprite_2d.svg")
class_name OneTimeAnimatedSprite2D
extends AnimatedSprite2D

@export var node_to_delete: Node = self


func _ready() -> void:
	animation_finished.connect(
		node_to_delete.queue_free,
		CONNECT_ONE_SHOT
	)
