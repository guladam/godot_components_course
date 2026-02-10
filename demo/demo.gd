extends Control

@export var component_list: ComponentList
@export var filter_button_group: ButtonGroup
@export var button_group: ButtonGroup

@onready var components: VBoxContainer = %Components
@onready var go_button: Button = %GoButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	for child: Node in components.get_children():
		child.queue_free()
	
	for i: int in component_list.component_names.size():
		var new_button := Button.new()
		components.add_child(new_button)
		new_button.text = component_list.component_names[i]
		new_button.toggle_mode = true
		new_button.button_group = button_group
		new_button.custom_minimum_size.y = 60
		new_button.button_pressed = i == 0
	
	go_button.pressed.connect(
		func() -> void:
			var i := button_group.get_pressed_button().get_index()
			BackButton.show()
			get_tree().change_scene_to_file(component_list.component_paths[i])
	)
	
	filter_button_group.pressed.connect(_on_filter_changed)
	exit_button.pressed.connect(get_tree().quit)

	BackButton.hide()


func _on_filter_changed(pressed: BaseButton) -> void:
	var filter_idx := pressed.get_index()
	var buttons := button_group.get_buttons()
	for i: int in buttons.size():
		buttons[i].visible = (filter_idx == 0) or (component_list.component_types[i] == (filter_idx-1))
	
