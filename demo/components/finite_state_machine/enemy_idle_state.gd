class_name EnemyIdleState
extends State

var enemy: Enemy


func enter() -> void:
	enemy = actor as Enemy
	enemy.timer.start()
	enemy.timer.timeout.connect(_on_timer_expired, CONNECT_ONE_SHOT)


func _on_timer_expired() -> void:
	enemy.finite_state_machine.change_state(EnemyPatrolState)
