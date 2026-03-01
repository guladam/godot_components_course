extends Node2D

@export var char_speed := 300
@export var dir := 1


func _ready() -> void:
	$Character/Timer.timeout.connect(func(): dir *= -1)


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("fire"):
		$SceneSpawner.spawn($Character/Weapon/Muzzle)
	if event is InputEventMouseMotion:
		$Character/Weapon.look_at(get_global_mouse_position())


func _process(delta: float) -> void:
	$Character.position += dir * Vector2.RIGHT * char_speed * delta
