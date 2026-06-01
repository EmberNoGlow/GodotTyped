class_name GDT_Compiler
extends RefCounted

func compile(ast: Array[GDT_AST.NodeAST], source_code: String) -> String:
	var output := ""
	
	for node in ast:
		if node is GDT_AST.ExtendsNode:
			output += "extends " + node.target_class + "\n\n"
			
		elif node is GDT_AST.VariableNode:
			var raw_val = source_code.substr(node.val_start, node.val_end - node.val_start)
			var godot_type = node.type_str
			if godot_type.begins_with("array"):
				# Turn array[String] into Array[String]
				godot_type = "Array" + godot_type.substr(5)
			output += "var %s: %s = %s\n" % [node.name, godot_type, raw_val]
			
		elif node is GDT_AST.FunctionNode:
			var args_str := ""
			for j in range(node.arguments.size()):
				var arg = node.arguments[j]
				args_str += "%s: %s" % [arg.name, arg.type]
				if j < node.arguments.size() - 1: args_str += ", "
				
			output += "func %s(%s) -> %s:\n" % [node.name, args_str, node.return_type]
			
			# Extract the exact block text from original source code (including indents)
			var raw_body = source_code.substr(node.body_start, node.body_end - node.body_start)
			
			# Clean up local types into 'var' or erase flow types
			raw_body = raw_body.replace("float ", "var ")
			raw_body = raw_body.replace("int ", "var ")
			raw_body = raw_body.replace("String ", "var ")
			raw_body = raw_body.replace("for var ", "for ")
			
			output += raw_body + "\n\n"
			
	return output
