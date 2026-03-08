@tool
@icon("wrap_2d.svg")
class_name Wrap2D
extends Node
## Automatically wraps a [Node2D] around the screen edges.
##
## This component detects when a target leaves the viewport and teleports it 
## to the opposite side. It supports all standard [Node2D] objects and correctly 
## handles [RigidBody2D]s via the [PhysicsServer2D]. It also listens to the viewport's
## [Viewport.size_changed] to update the screen size when needed.

## The [Node2D] to be wrapped. Defaults to the parent node.
@export var target: Node2D = get_parent():
	set(new_target):
		target = new_target
		update_configuration_warnings()

## If [code]true[/code], the target will wrap from left-to-right and vice versa.
@export var wrap_horizontally: bool = true
## If [code]true[/code], the target will wrap from top-to-bottom and vice versa.
@export var wrap_vertically: bool = false
## The distance beyond the screen edge (in pixels) before the wrap occurs.
@export var margin: float = 32.0

## The current cached size of the viewport.
var screen_size: Vector2


func _ready() -> void:
	_update_screen_size()
	get_viewport().size_changed.connect(_update_screen_size)


func _get_configuration_warnings() -> PackedStringArray:
	if not target or not target is Node2D:
		return ["No valid target set for the Wrap2D Component!"]
	else:
		return []


func _physics_process(_delta: float) -> void:
	if not target:
		return

	if target is RigidBody2D:
		_wrap_rigidbody(target)
	else:
		target.global_position = _calculate_wrap(target.global_position)

## Updates the [member screen_size] based on the current viewport dimensions.
func _update_screen_size() -> void:
	screen_size = get_viewport().get_visible_rect().size

## Calculates the new position for a given vector based on screen boundaries and [member margin].
func _calculate_wrap(pos: Vector2) -> Vector2:
	if wrap_horizontally:
		pos.x = wrapf(pos.x, -margin, screen_size.x + margin)
	if wrap_vertically:
		pos.y = wrapf(pos.y, -margin, screen_size.y + margin)
	
	return pos

## Specialized wrap logic for [RigidBody2D]s.
## [br][br]
## Uses [PhysicsServer2D] to modify the body state directly, 
## ensuring the physics simulation remains stable during teleportation.
func _wrap_rigidbody(body: RigidBody2D) -> void:
	var body_rid = body.get_rid()
	var state = PhysicsServer2D.body_get_direct_state(body_rid)
	
	if state:
		var current_pos = state.transform.origin
		var new_pos = _calculate_wrap(current_pos)
		
		if new_pos != current_pos:
			var new_transform = state.transform
			new_transform.origin = new_pos
			state.transform = new_transform
