@tool
class_name GodotTypedScriptLoader
extends ResourceFormatLoader

func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["gdt"])

func _handles_type(p_type: StringName) -> bool:
	return p_type == &"Script" or p_type == &"GodotTypedScript"

func _recognize_path(p_path: String, p_hint: StringName) -> bool:
	return p_path.get_extension() == "gdt"

func _get_resource_type(p_path: String) -> String:
	return "GodotTypedScript"

func _load(p_path: String, p_original_path: String, p_use_sub_threads: bool, p_cache_mode: int) -> Variant:
	if not FileAccess.file_exists(p_path):
		return ERR_FILE_NOT_FOUND
		
	var file = FileAccess.open(p_path, FileAccess.READ)
	var script = GodotTypedScript.new()
	script.set_source_code(file.get_as_text())
	return script
