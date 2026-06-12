extends Node2D

@export var arrow_scene: PackedScene


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		var new_arrow := arrow_scene.instantiate()
		new_arrow.global_rotation = $Character/Weapon/Muzzle.global_rotation
		new_arrow.global_position = $Character/Weapon/Muzzle.global_position
		get_tree().current_scene.add_child(new_arrow)
		new_arrow.get_node("VelocityMovement2D").gravity = 980 if %ArcedShot.button_pressed else 0
		new_arrow.get_node("VelocityMovement2D").rotate_based_on_velocity = %ArcedShot.button_pressed
	if event is InputEventMouseMotion:
		$Character/Weapon.look_at(get_global_mouse_position())
