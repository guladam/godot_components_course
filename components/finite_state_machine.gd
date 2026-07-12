@icon("finite_state_machine.svg")
class_name FiniteStateMachine
extends Node

@onready var parent: Node = get_parent()
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


	return current_state
