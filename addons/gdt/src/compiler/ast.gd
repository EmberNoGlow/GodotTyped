class_name GDT_AST

class NodeAST:
	pass

class ExtendsNode extends NodeAST:
	var target_class: String
	func _init(p_class: String): self.target_class = p_class

class ClassNameNode extends NodeAST:
	var name: String
	func _init(p_name: String):
		name = p_name

class AnnotationNode extends NodeAST:
	var annotation: String
	func _init(p_annotation: String):
		annotation = p_annotation

class ClassNode extends NodeAST:
	var name: String
	var body: Array[NodeAST]

	func _init(p_name: String, p_body: Array[NodeAST]):
		name = p_name
		body = p_body

class WhenNode extends NodeAST:
	var target: String
	var signal_name: String
	var callback_name: String

	func _init(
		p_target: String,
		p_signal: String,
		p_callback: String
	):
		target = p_target
		signal_name = p_signal
		callback_name = p_callback

class VariableNode extends NodeAST:
	var annotations: Array[String] = []

	var type_str: String
	var name: String

	var val_start: int
	var val_end: int

	func _init(
		p_type: String,
		p_name: String,
		p_start: int,
		p_end: int,
		p_annotations: Array[String] = []
	):
		type_str = p_type
		name = p_name

		val_start = p_start
		val_end = p_end

		annotations = p_annotations

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
