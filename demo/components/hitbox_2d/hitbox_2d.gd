extends Node2D

@export var spear_scene: PackedScene

var one_shot: bool = false

func _ready() -> void:
	%Button.pressed.connect(_spawn_spear)
	%OneShot.toggled.connect(func(enabled): one_shot = enabled)
	%InvincibleFirstEnemy.toggled.connect(
		func(enabled): 
			$Enemy1/Hurtbox2D.is_invincible = enabled
	)
	
	$Enemy1/Hurtbox2D.hit_received.connect(_on_enemy_hit.bind($Enemy1))
	$Enemy2/Hurtbox2D.hit_received.connect(_on_enemy_hit.bind($Enemy2))
	$Enemy3/Hurtbox2D.hit_received.connect(_on_enemy_hit.bind($Enemy3))


func _spawn_spear() -> void:
	var new_spear := spear_scene.instantiate()
	add_child(new_spear)
	new_spear.one_shot = one_shot
	new_spear.global_position = $ShootingDude/Hand.global_position


func _on_enemy_hit(_hitbox: Hitbox2D, enemy: Node2D) -> void:
	enemy.modulate = Color.RED
	enemy.rotation_degrees = -90
	enemy.position.y = 430
	await get_tree().create_timer(1).timeout
	enemy.rotation_degrees = 0
	enemy.position.y = 420
	enemy.modulate = Color.WHITE
