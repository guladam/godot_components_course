@tool
@icon("scene_spawner.svg")
class_name SceneSpawner
extends Node

@export var scene: PackedScene:
	set(new_scene):
		scene = new_scene
		update_configuration_warnings()

@export var spawn_top_level: bool = false
@export var match_transform_top_level: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	if not scene:
		return ["No scene assigned to the SceneSpawner!"]
	else:
		return []


func instantiate() -> Node:
	if not scene:
		return null
		
	return scene.instantiate()


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
