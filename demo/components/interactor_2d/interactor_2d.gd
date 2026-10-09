extends Node2D

@onready var bridge: TileMapLayer = %Bridge
@onready var lever: Interactable2D = %Lever
@onready var key: Interactable2D = %Key
@onready var door: Interactable2D = %Door
@onready var door_open: Sprite2D = %DoorOpen
@onready var input_icon: Sprite2D = %InputIcon
@onready var input_icon_2: Sprite2D = %InputIcon2
@onready var p1_interactor: Interactor2D = $Character/Interactor2D
@onready var p2_interactor: Interactor2D = $Character2/Interactor2D

var has_key := false
var lever_used := false


func _ready() -> void:
	p1_interactor.focused_interactable_changed.connect(_show_prompt.bind(input_icon))
	p2_interactor.focused_interactable_changed.connect(_show_prompt.bind(input_icon_2))
	lever.interacted.connect(_on_lever_used)
	key.interacted.connect(_on_key_grabbed)
	door.interacted.connect(_on_door_opened)


func _show_prompt(interactable: Interactable2D, icon: Sprite2D) -> void:
	if not interactable:
		icon.hide()
		return
		
	icon.global_position = interactable.global_position - Vector2(0, 96)
	icon.show()


func _on_lever_used(_interactor: Node2D) -> void:
	lever_used = not lever_used
	bridge.enabled = lever_used
	
	if not lever_used:
		lever.get_node("Sprite2D").region_rect.position.y = 512
	else:
		lever.get_node("Sprite2D").region_rect.position.y = 448


func _on_key_grabbed(_interactor: Node2D) -> void:
	has_key = true
	key.queue_free()


func _on_door_opened(_interactor: Node2D) -> void:
	if has_key:
		door.queue_free()
		door_open.show()
