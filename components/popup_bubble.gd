@icon("popup_bubble.svg")
class_name PopupBubble
extends Control
## A generic 2D world-anchored UI prompt bubble.
##
## Tracks a [Node2D] target in world space and projects its position 
## onto the UI canvas. Delegates all entrance, exit, and idle animations 
## to an attached [Juicer2D].

@export_group("Targeting")
## The [Node2D] target to track in world space.
@export var target_node: Node2D

## Screen-space pixel offset relative to the target's position (e.g., [code]Vector2(0, -60)[/code]).
@export var offset: Vector2 = Vector2(0, -60)

## Keeps the bubble pinned inside the visible viewport edges when the target moves off-screen.
@export var clamp_to_screen: bool = false

@export_group("Behavior")
## Duration in seconds before automatically dismissing. Set to [code]0.0[/code] for persistent bubbles.
@export var auto_hide_time: float = 0.0

@export_group("Nodes & Juice")
## Reference to the text label inside the bubble container.
@export var label: Label

## Reference to the icon image inside the bubble container.
@export var icon_rect: TextureRect

## Container node used for position centering and sizing calculations.
@export var content_container: Control

## The [Juicer2D] handling visual transitions for this bubble.
@export var juicer_2d: Juicer2D

@export_group("Juice Group Identifiers")
## [StringName] ID of the entrance animation configured inside the [Juicer2D].
@export var pop_in_group: StringName = &"pop_in"

## [StringName] ID of the exit animation configured inside the [Juicer2D].
@export var pop_out_group: StringName = &"pop_out"

## Optional [StringName] ID for an ongoing idle effect (e.g. floating bounce).
@export var idle_group: StringName = &"bounce"

var _auto_hide_timer: float = 0.0
var _is_active: bool = false


func _ready() -> void:
	if not content_container:
		content_container = self
		
	visible = false
	set_process(false)


func _process(delta: float) -> void:
	if not _is_active:
		return
		
	_update_position()
	_handle_auto_hide(delta)


## Displays the bubble with text and an optional icon texture, triggering the entrance juice.
func popup(text: String, icon: Texture2D = null) -> void:
	if label:
		label.text = text
		
	if icon_rect:
		icon_rect.texture = icon
		icon_rect.visible = (icon != null)
		
	_is_active = true
	_auto_hide_timer = auto_hide_time
	visible = true
	set_process(true)
	
	_update_position()
	
	if juicer_2d:
		juicer_2d.play(pop_in_group)
		
		# If a looping idle/bounce effect group is assigned, queue/play it
		if not idle_group.is_empty():
			juicer_2d.play(idle_group, true)


## Triggers the exit juice group and hides the component upon completion.
func dismiss() -> void:
	if not _is_active:
		return
		
	_is_active = false
	set_process(false)
	
	if juicer_2d:
		juicer_2d.play(pop_out_group)
		
		# Allow the exit animation time to play before setting visible = false
		var tree := get_tree()
		if tree:
			await tree.create_timer(0.2).timeout
			
	visible = false


func _update_position() -> void:
	if not is_instance_valid(target_node):
		return

	# Project 2D world coordinates onto screen space
	var screen_pos: Vector2 = target_node.get_global_transform_with_canvas().origin + offset

	# Center the container on the projected coordinate
	var half_size: Vector2 = content_container.size * 0.5
	var final_pos: Vector2 = screen_pos - half_size

	if clamp_to_screen:
		var viewport_rect: Rect2 = get_viewport_rect()
		final_pos.x = clamp(final_pos.x, 0.0, viewport_rect.size.x - content_container.size.x)
		final_pos.y = clamp(final_pos.y, 0.0, viewport_rect.size.y - content_container.size.y)

	global_position = final_pos


func _handle_auto_hide(delta: float) -> void:
	if auto_hide_time > 0.0:
		_auto_hide_timer -= delta
		if _auto_hide_timer <= 0.0:
			dismiss()
