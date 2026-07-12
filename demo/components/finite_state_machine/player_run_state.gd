class_name PlayerRunState
extends State

signal stopped
signal jump_pressed
signal fell

var player: Player


func enter() -> void:
	player = actor as Player
	player.animated_sprite_2d.play("run")


func physics_update(_delta: float) -> void:
	if not player:
		return

	var direction := Input.get_axis("move_left", "move_right")

	if not is_zero_approx(direction):
		player.velocity.x = direction * player.move_speed
		player.animated_sprite_2d.flip_h = direction < 0.0
	else:
		stopped.emit()
		return

	player.move_and_slide()

	if not player.is_on_floor():
		fell.emit()


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_pressed.emit()
