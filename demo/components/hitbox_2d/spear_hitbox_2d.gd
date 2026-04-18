extends Hitbox2D

@export var speed := 400


func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT * speed * delta
