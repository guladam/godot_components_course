@icon("interactor_2d.svg")
class_name Interactor2D
extends Area2D

signal focused_interactable_changed(interactable: Interactable2D)

@export_group("Input")
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var interact_input_action: StringName = &"ui_accept"

@export_group("Targeting")
@export var owner_node: Node2D

var _nearby_interactables: Array[Interactable2D] = []
var _current_focus: Interactable2D = null


func _ready() -> void:
	if not owner_node and get_parent() is Node2D:
		owner_node = get_parent() as Node2D

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event.is_action_pressed(interact_input_action):
		var target := get_best_interactable()
		if target:
			get_viewport().set_input_as_handled()
			target.interact(owner_node)
			refresh.call_deferred()


func get_best_interactable() -> Interactable2D:
	_cleanup_invalid_targets()
	if _nearby_interactables.is_empty():
		return null

	var best_target: Interactable2D = null
	var shortest_distance_sq: float = INF
	var global_origin: Vector2 = global_position

	for interactable in _nearby_interactables:
		if not interactable.monitorable:
			continue

		var dist_sq: float = global_origin.distance_squared_to(interactable.global_position)
		if dist_sq < shortest_distance_sq:
			shortest_distance_sq = dist_sq
			best_target = interactable

	return best_target


func refresh() -> void:
	_cleanup_invalid_targets()
	_update_focus()


func _update_focus() -> void:
	var new_focus := get_best_interactable()
	if new_focus != _current_focus:
		_current_focus = new_focus
		focused_interactable_changed.emit(_current_focus)

	set_process_unhandled_input(_current_focus != null)


func _cleanup_invalid_targets() -> void:
	_nearby_interactables = _nearby_interactables.filter(
		func(i: Interactable2D) -> bool: 
			return is_instance_valid(i) and i.is_inside_tree() and i.monitorable
	)


func _on_area_entered(area: Area2D) -> void:
	if area is Interactable2D and not _nearby_interactables.has(area):
		_nearby_interactables.append(area as Interactable2D)
		_update_focus()


func _on_area_exited(area: Area2D) -> void:
	if area is Interactable2D:
		_nearby_interactables.erase(area as Interactable2D)
		_update_focus()
