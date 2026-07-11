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
	finite_state_machine.change_state(PlayerIdleState)


func _process(_delta: float) -> void:
	label.text = finite_state_machine.current_state.get_script().get_global_name()
