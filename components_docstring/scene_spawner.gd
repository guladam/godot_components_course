@tool
@icon("scene_spawner.svg")
class_name SceneSpawner
extends Node
## Spawns a [PackedScene] to the current SceneTree.

## The [PackedScene] that will be spawned.
@export var scene: PackedScene:
	set(new_scene):
		scene = new_scene
		update_configuration_warnings()

## If [code]true[/code], the spawned scene will be added to the [member SceneTree.current_scene] 
## instead of the provided parent. Useful for objects that must exist independently 
## of the parent's movement (e.g., bullets).
@export var spawn_top_level: bool = false
## If [code]true[/code], the instance will copy the global position and rotation 
## of the [method spawn] method's [param parent] reference.
## [br][br]
## [b]Note:[/b] Only effective when [member spawn_top_level] is enabled.
@export var match_transform_top_level: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	if not scene:
		return ["No scene assigned to the SceneSpawner!"]
	else:
		return []

## Instantiates the [member scene] without adding it to the tree. 
## [br][br]
## Returns the new [Node] or [code]null[/code] if no scene is assigned. 
## Use this to modify properties on the instance before adding it manually to the tree.
func instantiate() -> Node:
	if not scene:
		return null
		
	return scene.instantiate()

## Spawns the [member scene] into the tree.
## [br][br]
## [param parent]: The Node to use as the parent (or spatial reference if both 
## [member spawn_top_level] and [member match_transform_top_level] are true). 
## Defaults to the [SceneSpawner]'s parent.
func spawn(parent: Node = get_parent()) -> Node:
	var new_node := instantiate()
	var spawn_source := parent
	
	if spawn_top_level:
		parent = get_tree().current_scene
	
	parent.add_child(new_node)
	
	if match_transform_top_level and spawn_top_level:
		if "global_position" in spawn_source and "global_position" in new_node:
			new_node.global_position = spawn_source.global_position
		if "global_rotation" in spawn_source and "global_rotation" in new_node:
			new_node.global_rotation = spawn_source.global_rotation
	
	return new_node

