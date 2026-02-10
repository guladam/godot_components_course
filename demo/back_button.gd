extends CanvasLayer

@export var title_screen: PackedScene


func _ready() -> void:
	$Button.pressed.connect(
		func() -> void:
			get_tree().change_scene_to_packed(title_screen)
	)
