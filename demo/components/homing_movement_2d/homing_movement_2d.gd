extends Node2D

@export var enemy_speed := 200
@export var arrow_scene: PackedScene
@onready var enemy: Area2D = $Enemy

var _enemy_start_position: Vector2
var _enemy_target_position: Vector2
var _enemy_velocity := Vector2.ZERO


func _ready() -> void:
	_enemy_start_position = enemy.global_position
	_new_enemy_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		var new_arrow := arrow_scene.instantiate()
		new_arrow.global_rotation = $Character/Weapon/Muzzle.global_rotation
		new_arrow.global_position = $Character/Weapon/Muzzle.global_position
		new_arrow.get_node("HomingMovement2D").target = $Enemy
		get_tree().current_scene.add_child(new_arrow)
	if event is InputEventMouseMotion:
		$Character/Weapon.look_at(get_global_mouse_position())


func _process(delta: float) -> void:
	_enemy_velocity = (_enemy_target_position - enemy.global_position).normalized() * enemy_speed
	enemy.global_position += _enemy_velocity * delta
	
	if enemy.global_position.distance_to(_enemy_target_position) < 5.0:
		_new_enemy_position()


func _new_enemy_position() -> void:
	_enemy_target_position = _enemy_start_position + Vector2(randi() % 300, randi() % 200)
