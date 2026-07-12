class_name Enemy
extends AnimatedSprite2D

@export var fly_speed: int = 300

@onready var left_ray_cast_2d: RayCast2D = $LeftRayCast2D
@onready var right_ray_cast_2d: RayCast2D = $RightRayCast2D
@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var finite_state_machine: FiniteStateMachine = $FiniteStateMachine

var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	_idle()


func _process(_delta: float) -> void:
	label.text = finite_state_machine.current_state.get_script().get_global_name()


func _idle() -> void:
	timer.wait_time = 2.0
	timer.start()
	finite_state_machine.change_state(EnemyIdleState)
	timer.timeout.connect(_patrol, CONNECT_ONE_SHOT)


func _patrol() -> void:
	timer.wait_time = 6.0
	timer.start(	)
	finite_state_machine.change_state(EnemyPatrolState)
	timer.timeout.connect(_idle, CONNECT_ONE_SHOT)
	
