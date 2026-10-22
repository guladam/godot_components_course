@tool
class_name ImportStatSheets
extends EditorScript

# TODO CHANGE THESE FOR YOUR GAME
const CSV_PATH: String = "res://demo/components/stat/stat_sheet.csv"
const OUTPUT_DIR: String = "res://demo/components/stat/stat_sheets/"


func _run() -> void:
	print("--- Starting StatSheets CSV Import ---")
	
	if not FileAccess.file_exists(CSV_PATH):
		printerr("CSV file not found at: ", CSV_PATH)
		return
	
	var dir := DirAccess.open("res://")
	if not dir.dir_exists(OUTPUT_DIR):
		dir.make_dir_recursive(OUTPUT_DIR)
		
	var file := FileAccess.open(CSV_PATH, FileAccess.READ)
	if not file:
		printerr("Failed to open CSV file at: ", CSV_PATH)
		return
	
	var headers := file.get_csv_line()
	if headers.is_empty():
		printerr("CSV file is empty.")
		return
		
	var imported_count: int = 0
	
	while not file.eof_reached():
		var row_values := file.get_csv_line()
		print(row_values)
		
		if row_values.size() < headers.size() or row_values[0].strip_edges().is_empty():
			continue
			
		var entity_name := row_values[0].strip_edges().to_lower()
		var stat_sheet := StatSheet.new()
		
		for i in range(1, headers.size()):
			var col_name := headers[i].strip_edges()
			var raw_value := row_values[i].strip_edges()
			
			if raw_value.is_empty():
				continue
			
			if col_name.ends_with("_max"):
				_handle_limit_line(stat_sheet, col_name, "_max", raw_value)
			elif col_name.ends_with("_min"):
				_handle_limit_line(stat_sheet, col_name, "_min", raw_value)
			else:
				var stat_name := col_name as StringName
				var def := StatDefinition.new()
				def.name = stat_name
				def.base_value = raw_value.to_float()
				stat_sheet.stat_definitions.append(def)
		
		var save_path := "%s%s.tres" % [OUTPUT_DIR, entity_name]
		var error := ResourceSaver.save(stat_sheet, save_path)
		
		if error == OK:
			print("Successfully imported: ", save_path)
			imported_count += 1
		else:
			printerr("Failed to save resource for: ", entity_name, " (Error code: ", error, ")")
			
	print("--- Import Complete! Successfully processed %d character(s) ---" % imported_count)


func _handle_limit_line(stat_sheet: StatSheet, col_name: String, suffix: String, value: String) -> void:
	var parent_stat_name := col_name.trim_suffix(suffix) as StringName
	var def: StatDefinition = null
	
	for previous_def: StatDefinition in stat_sheet.stat_definitions:
		if previous_def.name == parent_stat_name:
			def = previous_def
			break
	
	if not def:
		return
		
	match suffix:
		"_max":
			def.max_limit = value.to_float()
			def.has_max_limit = true
		"_min":
			def.min_limit = value.to_float()
			def.has_min_limit = true
