extends Node

func _ready():
	var code = """
extends Node

# MY COMMENT!!!

Array[String] my_array = [
	"Hello",
	"my Dear",
	"Alice"
]

Vector2 get_input_dir():
	return Input.get_vector("left", "right", "up", "down")

void _ready():
	float a = 1.0
	print(a + 1.5 - 0.5 / 2.0)
	
	String final_str = ""
	
	for String word in my_array:
		final_str += word + " "
	
	print(final_str)

void _physics_process(float delta):
	print(get_input_dir())
	"""
	
	print("--- ORIGINAL CODE ---")
	print(code)
	
	# 1. Run Lexer
	var tokens = GDT_Lexer.new().tokenize(code)
	
	# 2. Run Parser
	var ast = GDT_Parser.new().parse(tokens)
	
	# 3. Run Compiler (Translator)
	var final_gdscript = GDT_Compiler.new().compile(ast, code)
	
	print("\n--- TRANSLATED GDSCRIPT ---")
	print(final_gdscript)
