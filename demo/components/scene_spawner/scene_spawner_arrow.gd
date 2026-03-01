extends Sprite2D

@export var speed := 500


func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
