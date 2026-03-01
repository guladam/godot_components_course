@tool
class_name ComponentListGenerator
extends EditorScript

const COMPONENTS_SCRIPTS_FOLDER := "res://components/"
const COMPONENTS_DEMO_FOLDER := "res://demo/components/"
const LIST_RESOURCE_PATH := "res://demo/component_list.tres"

const TYPES := {
	"FlipSprite2D": "2D",
	"SceneSpawner": "GENERAL"
}

func _run() -> void:
	var component_paths: PackedStringArray = []
	var component_names: PackedStringArray = []
	var component_types: Array[ComponentList.ComponentCategories] = []
	var component_list := ComponentList.new()
	
	for file: String in DirAccess.get_files_at(COMPONENTS_SCRIPTS_FOLDER):
		if file.ends_with(".gd"):
			var name := file.to_pascal_case().trim_suffix(".gd").replace("2d", "2D")
			component_paths.append(
				COMPONENTS_DEMO_FOLDER + file.trim_suffix(".gd") + "/"
				+ file.trim_suffix(".gd") + ".tscn"
			)
			component_names.append(name)
			if name in TYPES:
				component_types.append(ComponentList.ComponentCategories["C_" + TYPES[name]])
			else:
				component_types.append(ComponentList.ComponentCategories.C_GENERAL)

	component_list.component_paths = component_paths
	component_list.component_names = component_names
	component_list.component_types = component_types
	
	if ResourceSaver.save(component_list, LIST_RESOURCE_PATH) == OK:
		print("List updated successfully.")
	else:
		print("Error when trying to save the new list!")
