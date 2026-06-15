@tool
class_name GodotTypedScriptSaver
extends ResourceFormatSaver

func _get_recognized_extensions(_p_resource: Resource) -> PackedStringArray:
	return PackedStringArray(["gdt"])

func _recognize(p_resource: Resource) -> bool:
	return p_resource is GodotTypedScript

func _save(p_resource: Resource, p_path: String, _p_flags: int) -> int:
	var script = p_resource as GodotTypedScript
	if not script:
		return ERR_INVALID_DATA
		
	var file = FileAccess.open(p_path, FileAccess.WRITE)
	if not file:
		return FileAccess.get_open_error()
		
	file.store_string(script.source_code)
	return OK
