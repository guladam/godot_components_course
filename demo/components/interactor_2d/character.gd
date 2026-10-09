extends CharacterBody2D

enum State {IDLE, RUN, FALL}

@export_custom(PROPERTY_HINT_INPUT_NAME, "") var left_action: StringName
@export_custom(PROPERTY_HINT_INPUT_NAME, "") var right_action: StringName
@export var move_speed: int = 300
@export var air_control: float = 0.75
@export var gravity: float = 980.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var state := State.IDLE

func _ready() -> void:
	_idle()


func _unhandled_input(event: InputEvent) -> void:
	if state == State.IDLE:
		_idle_input(event)


func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			_idle_physics(delta)
		State.RUN:
			_run_physics(delta)
		State.FALL:
			_fall_physics(delta)


func _idle() -> void:
	state = State.IDLE
	animated_sprite_2d.play("idle")
	velocity.x = 0.0


func _idle_input(_event: InputEvent) -> void:
	var direction := Input.get_axis(left_action, right_action)
	if not is_zero_approx(direction):
		_run()


func _idle_physics(_delta: float) -> void:
	move_and_slide()
	
	if not is_on_floor():
		_fall()


func _fall() -> void:
	state = State.FALL
	animated_sprite_2d.play("jump")
	velocity.y = 0


func _fall_physics(delta: float) -> void:
	var direction := Input.get_axis(left_action, right_action)
	if not is_zero_approx(direction):
		velocity.x = direction * move_speed * air_control
		animated_sprite_2d.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed * 2 * delta)
		
	velocity.y += gravity * delta
	move_and_slide()
	
	if is_on_floor():
		if not is_zero_approx(direction):
			_run()
		else:
			_idle()


func _run() -> void:
	state = State.RUN
	animated_sprite_2d.play("run")


func _run_physics(_delta: float) -> void:
	var direction := Input.get_axis(left_action, right_action)

	if is_zero_approx(direction):
		_idle()
		return

	velocity.x = direction * move_speed
	animated_sprite_2d.flip_h = direction < 0.0
	move_and_slide()

	if not is_on_floor():
		_fall()
