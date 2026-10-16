@icon("hurtbox_2d.svg")
class_name Hurtbox2D
extends Area2D

signal hit_received(hitbox: Hitbox2D)

@export var is_invincible: bool = false


func take_hit(hitbox: Hitbox2D) -> void:
	if is_invincible:
		return
	
	hit_received.emit(hitbox)
