@icon("one_time_animation_player.svg")
class_name OneTimeAnimationPlayer
extends AnimationPlayer

@export var node_to_delete: Node = self


func _ready() -> void:
	animation_finished.connect(
		node_to_delete.queue_free.unbind(1), 
		CONNECT_ONE_SHOT
	)
