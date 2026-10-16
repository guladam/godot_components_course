@tool
@icon("velocity_movement_2d.svg")
class_name VelocityMovement2D
extends Node

@export var target: Node2D:
	set(new_target):
		target = new_target
		update_configuration_warnings()

@export var speed: float = 500.0
@export var gravity: float = 0.0
@export var rotate_based_on_velocity: bool = false

var _velocity: Vector2


func _ready() -> void:
	if not target:
		target = get_parent()
	
	_velocity = Vector2.RIGHT.rotated(target.global_rotation) * speed


func _get_configuration_warnings() -> PackedStringArray:
	if not target or not target is Node2D:
		return ["No valid target set for the VelocityMovement2D Component!"]
	else:
		return []


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target) or Engine.is_editor_hint():
		return

	if gravity > 0:
		_velocity.y += gravity * delta
	target.global_position += _velocity * delta
	
	if rotate_based_on_velocity:
		target.rotation = _velocity.angle()
