@tool
extends EditorSyntaxHighlighter
class_name GDTSyntaxHighlighter

func _get_name() -> String:
	return "GDT Highlighting"

func _get_supported_languages() -> PackedStringArray:
	return PackedStringArray(["gdt"])
func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var result = {}
	var text_line = get_text_edit().get_line(line)
	
	if text_line.strip_edges().is_empty():
		return result

	var settings = EditorInterface.get_editor_settings()
	var color_keyword = settings.get_setting("text_editor/theme/highlighting/keyword_color")
	var color_control = settings.get_setting("text_editor/theme/highlighting/control_flow_keyword_color")
	var color_builtin = settings.get_setting("text_editor/theme/highlighting/engine_type_color")
	var color_string = settings.get_setting("text_editor/theme/highlighting/string_color")
	var color_comment = settings.get_setting("text_editor/theme/highlighting/comment_color")
	var color_number = settings.get_setting("text_editor/theme/highlighting/number_color")
	var color_normal = settings.get_setting("text_editor/theme/highlighting/text_color")
	
	var regex = RegEx.new()
	regex.compile("(\"[^\"]*\")|(#.*)|(\\b\\d+\\b)|(\\b\\w+\\b)")
	
	var matches = regex.search_all(text_line)
	var current_color = color_normal
	
	for m in matches:
		var token = m.get_string()
		var start_pos = m.get_start()
		var end_pos = m.get_end()
		var token_color = color_normal
		
		if token.begins_with("\""):
			token_color = color_string
		elif token.begins_with("#"):
			token_color = color_comment
		elif token.is_valid_int() or token.is_valid_float():
			token_color = color_number
		elif token in GodotTypedSyntaxConfig.flow_keyword:
			token_color = color_control
		elif token in GodotTypedSyntaxConfig.types_list:
			token_color = color_keyword
		elif end_pos < text_line.length() and text_line[end_pos] == "(":
			token_color = color_builtin

		if token_color != current_color:
			result[start_pos] = {"color": token_color}
			current_color = token_color
			
		if end_pos < text_line.length() and current_color != color_normal:
			result[end_pos] = {"color": color_normal}
			current_color = color_normal
			
	return result
