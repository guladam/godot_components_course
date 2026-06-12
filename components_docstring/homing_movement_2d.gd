@icon("homing_movement_2d.svg")
class_name HomingMovement2D
extends Node
## Applies smooth steering forces to drive the parent node toward a moving target.
##
## This component uses a steering force model 
## to simulate momentum. This creates natural, curved tracking paths and allows targets 
## to actively dodge or outmaneuver the pursuing projectile or entity. It automatically 
## aligns the parent's visual rotation with its current trajectory.

## The target [Node2D] that this component will pursue. 
## If invalid or freed, movement ceases.
@export var target: Node2D

## The maximum flight speed of the parent node in pixels per second.
@export var speed: float = 400.0

## The sharpness of the turning force. Higher values create aggressive tracking paths; 
## lower values allow wider, drifting arcs.
@export var steer_force: float = 5.0

## Internal tracker for the entity's current velocity vector.
var _velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
    # Initialize velocity pointing in the direction the owner is facing, 
	# ensuring a natural "launch forward" effect before tracking begins.
	_velocity = owner.transform.x * speed


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	
    # 1. Calculate the vector pointing directly at the target at maximum speed.
	var desired: Vector2 = (target.global_position - owner.global_position).normalized() * speed
	
    # 2. Compute a constant-magnitude steering vector toward the desired velocity.
    var steer: Vector2 = (desired - _velocity).normalized() * steer_force

    # 3. Apply the steering acceleration to our current velocity, capped by maximum speed.
	_velocity = (_velocity + steer * delta).limit_length(speed)
    
    # 4. Apply calculated vector to move and rotate the parent node.
	owner.global_position += _velocity * delta
	owner.global_rotation = _velocity.angle()
