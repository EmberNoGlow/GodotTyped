@tool
class_name GodotTypedScript
extends ScriptExtension

var _source_code: String = ""
var gdscript_instance: GDScript

func _get_language() -> ScriptLanguage:
	if Engine.has_meta("MyCustomLanguageInstance"):
		return Engine.get_meta("MyCustomLanguageInstance")
	return null

func _get_source_code() -> String:
	return _source_code 

func _set_source_code(p_code: String) -> void:
	_source_code = p_code
	_compile_to_gdscript()

func _compile_to_gdscript() -> void:
	if not gdscript_instance:
		gdscript_instance = GDScript.new()
	
	var compiled_code = "extends Node\n\nfunc _ready():\n\tprint('Hello from Mylang!!!')\n"
	
	gdscript_instance.source_code = compiled_code
	gdscript_instance.reload()

func _is_valid() -> bool:
	return true

func _is_tool() -> bool:
	return true

func _get_instance_base_type() -> StringName:
	return &"Node"

func _has_static_method(_p_method: StringName) -> bool:
	return false

func _can_instantiate() -> bool:
	return true

func _instance_create(p_object: Object) -> int:
	_compile_to_gdscript()
	
	p_object.set_script(gdscript_instance)
	
	return OK

func _get_documentation() -> Array[Dictionary]:
	return []

func _update_exports() -> void:
	pass

func _editor_can_reload_from_file() -> bool:
	return true

func _reload(_p_keep_state: bool) -> int:
	_compile_to_gdscript()
	return OK
