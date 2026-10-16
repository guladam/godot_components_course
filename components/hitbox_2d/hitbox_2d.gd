@icon("hitbox_2d.svg")
class_name Hitbox2D
extends Area2D

signal hit(hurtbox: Hurtbox2D)

@export var damage: float = 1.0
@export var one_shot: bool = false

var _has_hit: bool = false


func _init() -> void:
	monitoring = true
	monitorable = false 
	area_entered.connect(_on_area_entered)


func reset() -> void:
	_has_hit = false


func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox2D:
		return
	
	var hurtbox := area as Hurtbox2D
	var already_hit := one_shot and _has_hit
	
	if already_hit or hurtbox.is_invincible:
		return
	
	_has_hit = true
	hurtbox.take_hit(self)
	hit.emit(hurtbox)
