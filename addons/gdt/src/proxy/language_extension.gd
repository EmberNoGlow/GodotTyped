@tool
class_name GodotTypedLanguage
extends ScriptLanguageExtension

func _init() -> void:
	Engine.set_meta("GodotTypedLanguageInstance", self)

func _get_name() -> String:
	return "GodotTyped"

func _get_type() -> String:
	return "GodotTypedScript"

func _get_extension() -> String:
	return "gdt"

func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["gdt"])

func _create_script() -> Object:
	return GodotTypedScript.new()

func _handles_global_class_type(p_type: String) -> bool:
	return p_type == "GodotTypedScript" or p_type == "GodotTyped"

func _overrides_external_editor() -> bool:
	return false

func _get_reserved_words() -> PackedStringArray:
	return PackedStringArray([])

func _get_comment_delimiters() -> PackedStringArray:
	return PackedStringArray(["#"])

func _get_string_delimiters() -> PackedStringArray:
	return PackedStringArray(['" "', "' '"])

func _complete_code(_p_code: String, _p_path: String, _p_owner: Object) -> Dictionary:
	return {"result": OK, "matches": []}

func _lookup_code(_p_code: String, _p_symbol: String, _p_path: String, _p_owner: Object) -> Dictionary:
	return {"result": OK, "type": 0, "class": "", "path": "", "line": 0}

func _get_built_in_templates(p_object: StringName) -> Array[Dictionary]:
	return [{
		"inherit": p_object,
		"name": "Default",
		"description": "Basic GodotTyped Template",
		"content": "extends %s\n\n# Your code here!!!\n" % p_object,
		"id": 0,
		"origin": 0
	}]

func _make_template(p_template: String, p_class_name: String, p_base_class_name: String) -> Script:
	var scr = GodotTypedScript.new()
	var code = p_template.replace("_BASE_", p_base_class_name).replace("_CLASS_", p_class_name)
	if code.is_empty():
		code = "extends %s\n\n" % p_base_class_name
	scr.set_source_code(code)
	return scr

func _is_text_script() -> bool:
	return true

func _frame() -> void: pass
func _thread_enter() -> void: pass
func _thread_exit() -> void: pass
func _supports_documentation() -> bool: return false
func _is_control_flow_keyword(_p_keyword: String) -> bool: return false
func _can_inherit_from_file() -> bool: return false
func _can_make_function() -> bool: return true
func _supports_builtin_mode() -> bool: return false
func _is_using_templates() -> bool: return true
func _validate_path(p_path: String) -> String: return ""

func _validate(_p_script: String, _p_path: String, _p_validate_functions: bool, _p_validate_errors: bool, _p_validate_warnings: bool, _p_validate_safe_lines: bool) -> Dictionary:
	return {"valid": true, "errors": [], "warnings": [], "safe_lines": []}

func _get_global_class_name(_p_path: String) -> Dictionary:
	return {
		"base_type": &"Node",
		"class_name": &""
	}

func _auto_indent_code(_p_code: String, _p_from_line: int, _p_to_line: int) -> String:
	return "I really dont know"

func _find_function(_p_class_name: String, _p_function_name: String) -> int:
	return -1

func _reload_all_scripts() -> void:
	pass
