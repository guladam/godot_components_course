class_name EnemyPatrolState
extends State

var enemy: Enemy


func enter() -> void:
	enemy = actor as Enemy


func physics_update(delta: float) -> void:
	if enemy.left_ray_cast_2d.is_colliding() or enemy.right_ray_cast_2d.is_colliding():
		enemy.direction *= -1
		enemy.flip_h = not enemy.flip_h
	
	enemy.position += enemy.direction * enemy.fly_speed * delta
