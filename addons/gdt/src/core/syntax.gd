@tool
class_name GodotTypedSyntaxConfig
extends RefCounted

static var reserved_words : Array[String]
static var types_list : Array[String]

static var flow_keyword : Array[String] = [
	"extends", "class", "class_name",
	"if", "elif", "else", 
	"while", "for", "break", "continue",
	"in", "return",  "pass", "as", "is",
	"and", "or", "not",
	"true", "false", "null"
]

static func get_type_list() -> Array[String]:
	var result: Array[String] = []
	
	for i in range(TYPE_MAX):
		if i == TYPE_NIL:
			continue
			
		var name: String = type_string(i)
		result.append(name)
	
	result.append_array(ClassDB.get_class_list())
	return result

static func make_keywords():
	reserved_words.clear()
	types_list = get_type_list()
	types_list.append_array(["null", "void"])
	reserved_words.append_array(types_list)
	reserved_words.append_array(flow_keyword)
