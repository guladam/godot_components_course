@icon("finite_state_machine.svg")
class_name FiniteStateMachine
extends Node
## A lightweight Finite State Machine (FSM) implementation.
##
## This component manages actor behaviors by isolating logic into [State] classes.
## Instead of populating the scene tree with state nodes, 
## this machine instantiates state scripts dynamically into memory, 
## keeping the scene hierarchy clean.

## Emitted when [method change_state] successfully changes to a new [State].
signal state_changed

## Parent [Node] of the FSM. This Node is the actor 
## accessible for all [State]s.
@onready var parent := get_parent()

## The currently active lifecycle state.
var current_state: State


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.unhandled_input(event)


## Transitions the machine from the current state to a new state instance.
## [br][br]
## Accepts a raw [GDScript] class (e.g., [code]IdleState[/code]). Returns the newly 
## instantiated [State] object, or [code]null[/code] if the class type validation fails.
func change_state(new_state_class: GDScript) -> State:
	if current_state:
		current_state.exit()
        current_state = null

	var next = new_state_class.new()
	if not next is State:
		push_error("FSM: Class %s does not extend State." % new_state_class)
		return null
		
	current_state = next
	current_state.actor = parent
	current_state.enter()
    state_changed.emit()


	return current_state
