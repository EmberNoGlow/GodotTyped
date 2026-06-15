@tool
extends RefCounted
class_name GodotTypedCompilerBridge

static func compile(code: String) -> String:
	# 1. Run Lexer
	var tokens = GDT_Lexer.new().tokenize(code)
	# 2. Run Parser
	var ast = GDT_Parser.new().parse(tokens)
	# 3. Run Compiler (Translator)
	var gdscript = GDT_Compiler.new().compile(ast, code)
	# 4. Info
	print("GDT compilation complete")
	# 5. Return code
	return gdscript
