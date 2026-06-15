@tool
class_name GodotTypedScript
extends ScriptExtension

var _source_code: String = ""
var gdscript_instance: GDScript

func _get_language() -> ScriptLanguage:
	if Engine.has_meta("GodotTypedLanguageInstance"):
		return Engine.get_meta("GodotTypedLanguageInstance")
	return null

func _get_source_code() -> String:
	return _source_code 

func _set_source_code(p_code: String) -> void:
	_source_code = p_code
	_compile_to_gdscript()

func _compile_to_gdscript() -> void:
	if not gdscript_instance:
		gdscript_instance = GDScript.new()
	
	var base_type = _parse_base_type(_source_code)
	
	var compiled_code = "extends " + String(base_type) + "\n\n"
	compiled_code += "func _ready():\n"
	compiled_code += "\tprint('Hello from GodotTyped!!!')\n"
	
	gdscript_instance.source_code = compiled_code
	gdscript_instance.reload()

func _parse_base_type(code: String) -> StringName:
	var lines = code.split("\n")
	for line in lines:
		var trimmed = line.strip_edges()
		if trimmed.begins_with("extends "):
			return StringName(trimmed.replace("extends ", "").strip_edges())
	return &"Node"

func _is_valid() -> bool:
	return gdscript_instance != null and gdscript_instance.source_code != ""

func _is_tool() -> bool:
	return true

func _get_instance_base_type() -> StringName:
	return _parse_base_type(_source_code)

func _has_static_method(_p_method: StringName) -> bool:
	return false

func _can_instantiate() -> bool:
	return true

func _instance_create(p_object: Object) -> int:
	_compile_to_gdscript()
	
	if gdscript_instance:
		p_object.set_script(gdscript_instance)
	
	return 0

func _get_script_property_list() -> Array[Dictionary]:
	if gdscript_instance:
		return gdscript_instance.get_script_property_list()
	return []

func _has_property_default_value(_p_property: StringName) -> bool:
	return false

func _get_property_default_value(_p_property: StringName) -> Variant:
	return null

func _get_script_method_list() -> Array[Dictionary]:
	if gdscript_instance:
		return gdscript_instance.get_script_method_list()
	return []

func _get_script_signal_list() -> Array[Dictionary]:
	if gdscript_instance:
		return gdscript_instance.get_script_signal_list()
	return []

func _inherits_script(p_script: Script) -> bool:
	if gdscript_instance:
		return gdscript_instance.inherits_script(p_script)
	return false

func _get_documentation() -> Array[Dictionary]:
	return []

func _update_exports() -> void:
	pass

func _editor_can_reload_from_file() -> bool:
	return true

func _reload(_p_keep_state: bool) -> int:
	_compile_to_gdscript()
	return OK

func _has_source_code() -> bool:
	return true
