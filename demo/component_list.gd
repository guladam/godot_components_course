class_name ComponentList
extends Resource

enum ComponentCategories {
	C_2D,
	C_AI,
	C_GENERAL,
	C_TILEMAP,
	C_UI
}

@export var component_paths: PackedStringArray
@export var component_names: PackedStringArray
@export var component_types: Array[ComponentCategories]
