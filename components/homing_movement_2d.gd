@icon("homing_movement_2d.svg")
class_name HomingMovement2D
extends Node

@export var target: Node2D
@export var speed: float = 400.0
@export var steer_force: float = 5.0

var _velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	_velocity = owner.transform.x * speed


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	var desired: Vector2 = (target.global_position - owner.global_position).normalized() * speed
	var steer: Vector2 = (desired - _velocity).normalized() * steer_force
	_velocity = (_velocity + steer * delta).limit_length(speed)
	owner.global_position += _velocity * delta
	owner.global_rotation = _velocity.angle()
