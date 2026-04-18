@icon("hitbox_2d.svg")
class_name Hitbox2D
extends Area2D
## A component that detects [Hurtbox2D] areas to deliver damage.
##
## The Hitbox2D is the "offensive" part of the combat system. It should be 
## attached to projectiles, swords, or hazard zones. It looks for 
## [Hurtbox2D] areas and calls their [method Hurtbox2D.take_hit] method.

## Emitted when a hit is successfully landed on a valid [Hurtbox2D].
signal hit(hurtbox: Hurtbox2D)

## The amount of damage to be dealt to the [Hurtbox2D].
@export var damage: float = 1.0
## If [code]true[/code], this hitbox will only land a hit once. 
## Useful for projectiles or single-hit strikes to prevent damaging 
## multiple targets or the same target twice in one frame.
@export var one_shot: bool = false

## Internal flag to track if a hit has already been landed when [member one_shot] is enabled.
var _has_hit: bool = false


func _init() -> void:
	monitoring = true
	monitorable = false 
	area_entered.connect(_on_area_entered)


## Resets the [member _has_hit] status, allowing a [member one_shot] hitbox to hit again.
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
