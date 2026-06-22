extends Node2D


func _ready() -> void:
	%Speed25.pressed.connect(_set_speed.bind(0.25))
	%Speed50.pressed.connect(_set_speed.bind(0.5))
	%Speed100.pressed.connect(_set_speed.bind(1.0))
	
	%BufferSlider.value_changed.connect(
		func(value: float) -> void:
			%BufferLabel.text = "Buffer time: %ss" % value
			%Character/InputBuffer.buffer_time = value
	)


func _set_speed(speed: float) -> void:
	Engine.time_scale = speed


func _process(_delta: float) -> void:
	if %Character/InputBuffer.is_buffered():
		%Status.text = "Jump buffered for:\n%.2fs" % [%Character/InputBuffer._buffer_timer]
	else:
		%Status.text = "Press Space\nto Jump"


func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_jump()
	%Character.move_and_slide()
	_handle_animations()


func _handle_gravity(delta: float) -> void:
	if not %Character.is_on_floor():
		%Character.velocity.y += 980 * delta


func _handle_jump() -> void:
	var jump_pressed: bool = Input.is_action_pressed("fire")
	var is_jump_buffered: bool = %Character/InputBuffer.is_buffered()
	
	if %Character.is_on_floor() and (jump_pressed or is_jump_buffered):
		%Character.velocity.y = -600
		%Character/InputBuffer.consume()


func _handle_animations() -> void:
	if %Character.is_on_floor():
		%Character/AnimatedSprite2D.play("idle")
	elif %Character.velocity.y > 0:
		%Character/AnimatedSprite2D.play("fall")
	else:
		%Character/AnimatedSprite2D.play("jump")
