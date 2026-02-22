extends Node2D

var enabled := false


func _ready() -> void:
	%ToggleButton.pressed.connect(
		func():
			enabled = not enabled
			%ToggleButton.text = "flip towards mouse:\n%s" % ("enabled" if enabled else "disabled")
	)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and enabled:
		$Avatar/FlipSprite2D.flip_sprite_towards(get_global_mouse_position())
		$Avatar2/FlipSprite2D.flip_sprite_towards(get_global_mouse_position())
		$Avatar3/FlipSprite2D.flip_sprite_towards(get_global_mouse_position())
