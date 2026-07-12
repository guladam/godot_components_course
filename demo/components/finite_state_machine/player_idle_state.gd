class_name PlayerIdleState
extends State

signal jump_pressed
signal move_pressed

var player: Player


func enter() -> void:
	player = actor as Player
	player.animated_sprite_2d.play("idle")
	player.velocity.x = 0.0


func physics_update(_delta: float) -> void:
	if not player:
		return
	
	player.move_and_slide()


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_pressed.emit()
	else:
		var direction := Input.get_axis("move_left", "move_right")
		if not is_zero_approx(direction):
			move_pressed.emit()
