@tool
@icon("flip_sprite_2d.svg")
class_name FlipSprite2D
extends Node
## Flips a [Sprite2D] or an [AnimatedSprite2D] towards the direction of a [Vector2] position.

## The Sprite node that will be flipped.
## [br][br]
## Note: it is defined as a [Node2D] but it needs to be
## either a [Sprite2D] or an [AnimatedSprite2D].
@export var sprite: Node2D:
	set(node_2d):
		sprite = node_2d
		update_configuration_warnings()

## If [code]true[/code], the [member FlipSprite2D.sprite] can be flipped horizontally.
@export var flip_h: bool = true
## If [code]true[/code], the [member FlipSprite2D.sprite] can be flipped vertically.
@export var flip_v: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	if not sprite:
		return ["FlipSprite2D needs to have a sprite target set to work!"]
	elif not sprite is Sprite2D and not sprite is AnimatedSprite2D:
		return ["The set sprite target is neither a Sprite2D nor an AnimatedSprite2D!"]
	else:
		return []

## Flips the [member FlipSprite2D.sprite] towards the direction of an [param other_position].
## [br]
## This method should be called by the owner whenever the
## [member FlipSprite2D.sprite] might needs to be flipped.
func flip_sprite_towards(other_position: Vector2) -> void:
	var new_dir: Vector2 = sprite.global_position.direction_to(other_position)
	
	if flip_h and sign(new_dir.x) != 0:
		sprite.flip_h = sign(new_dir.x) == 1
	if flip_v and sign(new_dir.y) != 0:
		sprite.flip_v = sign(new_dir.y) == -1
