class_name GDT_Compiler
extends RefCounted

func normalize_indent(text: String) -> String:
	var lines = text.split("\n")

	var min_indent := 999999

	for line in lines:
		if line.strip_edges() == "":
			continue

		var count := 0

		while count < line.length() and line[count] == "\t":
			count += 1

		min_indent = min(min_indent, count)

	if min_indent == 999999:
		return text

	for i in range(lines.size()):
		if lines[i].strip_edges() == "":
			continue

		lines[i] = lines[i].substr(min_indent)

	return "\n".join(lines)

func compile_node(
	node: GDT_AST.NodeAST,
	source_code: String
) -> String:

	if node is GDT_AST.ExtendsNode:
		return "extends %s\n\n" % node.target_class

	if node is GDT_AST.ClassNameNode:
		return "class_name %s\n\n" % node.name

	if node is GDT_AST.ClassNode:
		var output := ""

		output += "class %s:\n" % node.name

		for child in node.body:
			var child_code = compile_node(
				child,
				source_code
			)

			output += child_code.indent("\t")

		output = output.strip_edges(false, true) + "\n\n"

		return output

	if node is GDT_AST.VariableNode:
		var raw_val = source_code.substr(
			node.val_start,
			node.val_end - node.val_start
		)

		var godot_type = node.type_str

		if godot_type.begins_with("array"):
			godot_type = "Array" + godot_type.substr(5)

		var annotation_str := ""

		for annotation in node.annotations:
			annotation_str += "@%s " % annotation

		return "%svar %s: %s = %s\n" % [
			annotation_str,
			node.name,
			godot_type,
			raw_val
		]

	if node is GDT_AST.FunctionNode:
		var args_str := ""

		for j in range(node.arguments.size()):
			var arg = node.arguments[j]

			args_str += "%s: %s" % [
				arg.name,
				arg.type
			]

			if j < node.arguments.size() - 1:
				args_str += ", "

		var output := ""

		output += "func %s(%s) -> %s:\n" % [
			node.name,
			args_str,
			node.return_type
		]

		var raw_body = source_code.substr(
			node.body_start,
			node.body_end - node.body_start
		)

		raw_body = normalize_indent(raw_body)

		raw_body = raw_body.replace("float ","var ")
		raw_body = raw_body.replace("int ","var ")
		raw_body = raw_body.replace("String ","var ")
		raw_body = raw_body.replace("for var ","for ")

		raw_body = raw_body.indent("\t")

		output += raw_body + "\n\n"

		return output

	return ""

func compile(
	ast: Array[GDT_AST.NodeAST],
	source_code: String
) -> String:

	var output := ""

	for node in ast:
		output += compile_node(
			node,
			source_code
		)

	return output
