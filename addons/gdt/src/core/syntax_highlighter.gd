@tool
extends EditorSyntaxHighlighter
class_name GDTSyntaxHighlighter

func _get_name() -> String:
	return "GDT Highlighting"

func _get_supported_languages() -> PackedStringArray:
	return PackedStringArray(["gdt"])

func hl_setting(editor_settings, setting: String):
	setting = "text_editor/theme/highlighting/"+setting+"_color"
	return editor_settings.get_setting(setting)

func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var result = {}
	var text_line = get_text_edit().get_line(line)
	
	if text_line.strip_edges().is_empty():
		return result

	var sets = EditorInterface.get_editor_settings()
	var color_keyword  = hl_setting(sets, "keyword")
	var color_control  = hl_setting(sets, "control_flow_keyword")
	var color_function = hl_setting(sets, "function")
	var color_type     = hl_setting(sets, "base_type")
	var color_builtin  = hl_setting(sets, "engine_type")
	var color_string   = hl_setting(sets, "string")
	var color_comment  = hl_setting(sets, "comment")
	var color_number   = hl_setting(sets, "number")
	var color_normal   = hl_setting(sets, "text")
	
	var regex = RegEx.new()
	regex.compile(r"(\B@\w+)|(\"[^\"]*\")|(#.*)|(\b\d+\b)|(\b\w+\b)")
	
	var matches = regex.search_all(text_line)
	var current_color = color_normal
	
	for m in matches:
		var token = m.get_string()
		var start_pos = m.get_start()
		var end_pos = m.get_end()
		var token_color = color_normal
		
		if token.begins_with("@"):
			token_color = Color(1.0, 0.708, 0.434, 1.0) # idk
		if token.begins_with("\""):
			token_color = color_string
		elif token.begins_with("#"):
			token_color = color_comment
		elif token.is_valid_int() or token.is_valid_float():
			token_color = color_number
		elif token in GodotTypedSyntaxConfig.flow_keyword:
			token_color = color_control
		elif token in GodotTypedSyntaxConfig.types_list:
			token_color = color_keyword # or color_type
		elif end_pos < text_line.length() and text_line[end_pos] == "(":
			token_color = color_function

		if token_color != current_color:
			result[start_pos] = {"color": token_color}
			current_color = token_color
			
		if end_pos < text_line.length() and current_color != color_normal:
			result[end_pos] = {"color": color_normal}
			current_color = color_normal
			
	return result
