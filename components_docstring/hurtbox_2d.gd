@icon("hurtbox_2d.svg")
class_name Hurtbox2D
extends Area2D
## A component that receives damage from [Hitbox2D] areas.
##
## The Hurtbox2D is the "defensive" part of the combat system. It should be 
## attached to players, enemies, or destructible objects. It provides an 
## interface for hit detection and handles invincibility states.

## Emitted when a valid [Hitbox2D] successfully lands a hit on this area.
signal hit_received(hitbox: Hitbox2D)

## If [code]true[/code], the hurtbox will ignore all incoming hits. 
## Use this for "I-frames" (invincibility frames) after taking damage 
## or during specific character states like rolling or dashing.
@export var is_invincible: bool = false

## Processes an incoming hit from a [Hitbox2D].
## [br][br]
## This is called automatically by the [Hitbox2D] when it enters this area. 
## It checks for [member is_invincible] before emitting [signal hit_received].
func take_hit(hitbox: Hitbox2D) -> void:
	if is_invincible:
		return
	
	hit_received.emit(hitbox)
