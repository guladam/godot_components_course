class_name PlayerJumpState
extends State

signal landed
signal landed_with_movement

var player: Player


func enter() -> void:
	player = actor as Player
	player.animated_sprite_2d.play("jump")
	player.velocity.y = player.jump_force


func physics_update(delta: float) -> void:
	if not player:
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	if not is_zero_approx(direction):
		player.velocity.x = direction * player.move_speed * 0.7
		player.animated_sprite_2d.flip_h = direction < 0.0
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.move_speed * 2 * delta)
		
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor():
		if not is_zero_approx(direction):
			landed_with_movement.emit()
		else:
			landed.emit()
