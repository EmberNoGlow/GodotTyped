class_name GDT_AST

class NodeAST:
	pass

class ExtendsNode extends NodeAST:
	var target_class: String
	func _init(p_class: String): self.target_class = p_class

class VariableNode extends NodeAST:
	var type_str: String
	var name: String
	var val_start: int
	var val_end: int
	func _init(p_type: String, p_name: String, p_start: int, p_end: int):
		self.type_str = p_type
		self.name = p_name
		self.val_start = p_start
		self.val_end = p_end

class FunctionNode extends NodeAST:
	var return_type: String
	var name: String
	var arguments: Array[Dictionary]
	var body_start: int
	var body_end: int
	func _init(p_ret: String, p_name: String, p_args: Array[Dictionary], p_start: int, p_end: int):
		self.return_type = p_ret
		self.name = p_name
		self.arguments = p_args
		self.body_start = p_start
		self.body_end = p_end
