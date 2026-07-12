class_name Player
extends CharacterBody2D

@export var move_speed: int = 300
@export var jump_force: int = -600
@export var air_control: float = 0.75
@export var gravity: float = 980.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label
@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine


func _ready() -> void:
	_idle()


func _process(_delta: float) -> void:
	label.text = finite_state_machine.current_state.get_script().get_global_name()


func _idle() -> void:
	var idle_state := finite_state_machine.change_state(PlayerIdleState) as PlayerIdleState
	idle_state.jump_pressed.connect(_jump, CONNECT_ONE_SHOT)
	idle_state.move_pressed.connect(_run, CONNECT_ONE_SHOT)


func _jump() -> void:
	var jump_state := finite_state_machine.change_state(PlayerJumpState) as PlayerJumpState
	jump_state.landed.connect(_idle, CONNECT_ONE_SHOT)
	jump_state.landed_with_movement.connect(_run, CONNECT_ONE_SHOT)


func _run() -> void:
	var run_state := finite_state_machine.change_state(PlayerRunState) as PlayerRunState
	run_state.stopped.connect(_idle, CONNECT_ONE_SHOT)
	run_state.fell.connect(_fall, CONNECT_ONE_SHOT)
	run_state.jump_pressed.connect(_jump, CONNECT_ONE_SHOT)


func _fall() -> void:
	_jump()
	velocity.y = 0.0	
