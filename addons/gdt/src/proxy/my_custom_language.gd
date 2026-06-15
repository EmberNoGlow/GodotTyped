@tool
class_name GodotTypedLanguage
extends ScriptLanguageExtension

func _init() -> void:
	Engine.set_meta("MyCustomLanguageInstance", self)

func _get_name() -> String:
	return "GodotTyped"

func _get_type() -> String:
	return "GodotTypedScript"

func _get_extension() -> String:
	return "gdt"

func _create_script() -> Object:
	return GodotTypedScript.new()

func _handles_global_class_type(p_type: String) -> bool:
	return p_type == "GodotTypedScript"

func _overrides_external_editor() -> bool:
	return false

# YOUR SYNTAX HIGHLIGHT HERE
func _get_reserved_words() -> PackedStringArray:
	return PackedStringArray(["func", "var", "if", "else", "return", "while", "for", "print"])

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
		"description": "Basic MyLang Template",
		"content": "# Your code here!!!\n"
	}]

func _is_text_script() -> bool:
	return true

func _frame() -> void: pass
func _thread_enter() -> void: pass
func _thread_exit() -> void: pass
func _supports_documentation() -> bool: return false
func _is_control_flow_keyword(_p_keyword: String) -> bool: return false
func _can_inherit_from_file() -> bool: return false

func _validate(_p_script: String, _p_path: String, _p_validate_functions: bool, _p_validate_errors: bool, _p_validate_warnings: bool, _p_validate_safe_lines: bool) -> Dictionary:
	return {"valid": true, "errors": [], "warnings": [], "safe_lines": []}

func _get_global_class_name(_p_path: String) -> Dictionary:
	return {
		"base_type": &"",
		"class_name": &""
	}

func _auto_indent_code(_p_code: String, _p_from_line: int, _p_to_line: int) -> String:
	return "I realy dont know"

func _find_function(_p_class_name: String, _p_function_name: String) -> int:
	return -1

func _reload_all_scripts() -> void:
	pass
