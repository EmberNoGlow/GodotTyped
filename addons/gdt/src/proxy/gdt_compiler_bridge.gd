@tool
extends RefCounted
class_name GodotTypedCompilerBridge

static func compile(code: String, file_path: String = "") -> String:
	var t0 := Time.get_ticks_usec()

	# 1. Run Lexer
	var tokens = GDT_Lexer.new().tokenize(code)
	var t1 := Time.get_ticks_usec()

	# 2. Run Parser
	var ast = GDT_Parser.new().parse(tokens)
	var t2 := Time.get_ticks_usec()

	# 3. Run Compiler (Translator)
	var gdscript = GDT_Compiler.new().compile(ast, code)

	# 4. Info
	var total_ms := (t2 - t0) / 1000.0
	var lex_ms := (t1 - t0) / 1000.0
	var parse_ms := (t2 - t1) / 1000.0

	var file_label := ""
	if not file_path.is_empty():
		file_label = "[b]%s[/b] " % file_path.get_file()

	var is_slow := total_ms > 10.0
	var time_color := "coral" if total_ms > 50.0 else ("gold" if is_slow else "light_green")
	
	var details := ""
	if is_slow or OS.is_stdout_verbose():
		details = " [color=gray](Lex: %.2f ms | Parse: %.2f ms)[/color]" % [lex_ms, parse_ms]

	print_rich("[color=cornflower_blue][b][GDT][/b][/color] [color=green]✔[/color] %scompiled in [color=%s]%.2f ms[/color]%s" % [
		file_label, time_color, total_ms, details
	])

	# 5. Return code
	return gdscript
