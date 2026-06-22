@icon("input_buffer.svg")
class_name InputBuffer
extends Node
## Captures and holds a specific input action within a short physics-timed window.
##
## This component prevents "eaten inputs" by caching a button press right before 
## an actor is ready to act (e.g., pressing jump 0.1 seconds before touching the ground). 
## It tracks the window via physics ticks for deterministic state machine synchronization.

## The engine input action string to listen for (defined in [b]Project Settings -> Input Map[/b]).
@export var action_name: StringName = &"jump"

## How long the input remains valid in seconds before expiring.
@export var buffer_time: float = 0.15

var _buffer_timer: float = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(action_name):
		_buffer_timer = buffer_time


func _physics_process(delta: float) -> void:
	if _buffer_timer > 0.0:
		_buffer_timer -= delta

## Returns [code]true[/code] if the action was pressed within the valid buffer time window.
## [br][br]
## This does [b]not[/b] clear the buffer!
func is_buffered() -> bool:
	return _buffer_timer > 0.0

## Clears the buffer window immediately. 
## [br][br]
## Call this when successfully executing an action to prevent double-firing bugs.
func consume() -> void:
	_buffer_timer = 0.0
