@tool
@icon("velocity_movement_2d.svg")
class_name VelocityMovement2D
extends Node
## Moves a target [Node2D] using a velocity vector with optional gravity acceleration.
##
## This component handles standard linear trajectories (like bullets or lasers) 
## when gravity is zero, but it can also handle smoothly parabolic arcs (like grenades or arrows) 
## when gravity is applied. It establishes its initial heading angle based on the target's 
## rotation and optionally updates the target's visual rotation to match its shifting trajectory.

## The target [Node2D] that this component will manipulate and move. 
## Defaults to the component's parent node if left unassigned.
@export var target: Node2D:
	set(new_target):
		target = new_target
		update_configuration_warnings()

## The travel speed of the target node in pixels per second.
@export var speed: float = 500.0

## The downward acceleration applied to the movement over time. 
## Set to 0.0 for straight, linear trajectories.
@export var gravity: float = 0.0

## If true, dynamically updates the target's visual rotation to always align 
## with its current velocity vector (useful for arcing projectiles like arrows).
@export var rotate_based_on_velocity: bool = false

## Internal tracker for the current translation velocity vector.
var _velocity: Vector2


func _ready() -> void:
	if not target:
		target = get_parent()
	
    # Calculate the initial velocity vector pointing in the direction 
	# the target is currently facing.
	_velocity = Vector2.RIGHT.rotated(target.global_rotation) * speed


func _get_configuration_warnings() -> PackedStringArray:
	if not target or not target is Node2D:
		return ["No valid target set for the VelocityMovement2D Component!"]
	else:
		return []


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target) or Engine.is_editor_hint():
		return

    # 1. Apply downward gravity acceleration over time if configured.
	if gravity > 0:
		_velocity.y += gravity * delta

    # 2. Translate the target node's position along the velocity vector.
	target.global_position += _velocity * delta
	
    # 3. Adjust the target's visual orientation to match its flight path if enabled.
	if rotate_based_on_velocity:
		target.rotation = _velocity.angle()
