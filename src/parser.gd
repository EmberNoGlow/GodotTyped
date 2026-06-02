class_name GDT_Parser
extends RefCounted

var tokens: Array[GDT_Lexer.Token] = []
var current := 0

func parse(p_tokens: Array[GDT_Lexer.Token]) -> Array[GDT_AST.NodeAST]:
	self.tokens = p_tokens
	self.current = 0
	var ast: Array[GDT_AST.NodeAST] = []
	
	while not is_at_end():
		if match_token(GDT_Lexer.TokenType.NEWLINE): continue
		var node = parse_statement()
		if node != null: ast.append(node)
	return ast

func parse_statement() -> GDT_AST.NodeAST:
	var annotations: Array[String] = []

	while check(GDT_Lexer.TokenType.AT):
		annotations.append(
			parse_annotation()
		)

	if match_keyword_flow("extends"):
		return parse_extends()

	if check_identifier("class_name"):
		return parse_class_name()

	if check_identifier("class"):
		return parse_class()

	if check(GDT_Lexer.TokenType.KEYWORD_TYPE):
		return parse_declaration(annotations)

	if check(GDT_Lexer.TokenType.IDENTIFIER):
		if peek_next() != null:
			if peek_next().type == GDT_Lexer.TokenType.IDENTIFIER:
				return parse_declaration(annotations)

	advance()
	return null

func parse_extends() -> GDT_AST.ExtendsNode:
	var name_token = consume(GDT_Lexer.TokenType.IDENTIFIER, "Expect class name.")
	return GDT_AST.ExtendsNode.new(name_token.value)

func check_identifier(name: String) -> bool:
	if not check(GDT_Lexer.TokenType.IDENTIFIER):
		return false
	return peek().value == name

func parse_class_name() -> GDT_AST.ClassNameNode:
	advance()

	var name_token = consume(
		GDT_Lexer.TokenType.IDENTIFIER,
		"Expected class name"
	)

	return GDT_AST.ClassNameNode.new(
		name_token.value
	)

func parse_class() -> GDT_AST.ClassNode:
	advance()

	var name_token = consume(
		GDT_Lexer.TokenType.IDENTIFIER,
		"Expected class name"
	)

	consume(
		GDT_Lexer.TokenType.COLON,
		"Expected ':'"
	)

	consume(
		GDT_Lexer.TokenType.NEWLINE,
		"Expected newline"
	)

	consume(
		GDT_Lexer.TokenType.INDENT,
		"Expected indent"
	)

	var body: Array[GDT_AST.NodeAST] = []

	while not check(GDT_Lexer.TokenType.DEDENT):
		if match_token(GDT_Lexer.TokenType.NEWLINE):
			continue

		var node = parse_statement()

		if node != null:
			body.append(node)

	consume(
		GDT_Lexer.TokenType.DEDENT,
		"Expected dedent"
	)

	return GDT_AST.ClassNode.new(
		name_token.value,
		body
	)

func parse_annotation() -> String:
	consume(
		GDT_Lexer.TokenType.AT,
		"Expected @"
	)

	return consume(
		GDT_Lexer.TokenType.IDENTIFIER,
		"Expected annotation name"
	).value

func parse_declaration(annotations: Array[String] = []) -> GDT_AST.NodeAST:
	var type_token = advance()
	var type_str = type_token.value
	if match_token(GDT_Lexer.TokenType.LBRACKET):
		type_str += "[" + advance().value + "]"
		consume(GDT_Lexer.TokenType.RBRACKET, "Expect ']'")
		
	var name_token = consume(GDT_Lexer.TokenType.IDENTIFIER, "Expect name.")
	
	if match_token(GDT_Lexer.TokenType.LPAREN):
		var args: Array[Dictionary] = []
		while not check(GDT_Lexer.TokenType.RPAREN) and not is_at_end():
			var arg_type = advance().value
			var arg_name = consume(GDT_Lexer.TokenType.IDENTIFIER, "Expect arg name.").value
			args.append({"name": arg_name, "type": arg_type})
			if not match_token(GDT_Lexer.TokenType.COMMA): break
		consume(GDT_Lexer.TokenType.RPAREN, "Expect ')'")
		consume(GDT_Lexer.TokenType.COLON, "Expect ':'")
		consume(GDT_Lexer.TokenType.NEWLINE, "Expect newline")
		
		# FIX: Grab body start position right here (before INDENT token)
		var body_start := peek().start_pos 
		consume(GDT_Lexer.TokenType.INDENT, "Expect indent")
		
		var body_end := body_start
		var indent_level := 1
		
		while indent_level > 0 and not is_at_end():
			if check(GDT_Lexer.TokenType.INDENT): indent_level += 1
			if check(GDT_Lexer.TokenType.DEDENT): indent_level -= 1
			var t = advance()
			if indent_level > 0:
				body_end = t.end_pos
				
		return GDT_AST.FunctionNode.new(type_str, name_token.value, args, body_start, body_end)
		
	elif match_token(GDT_Lexer.TokenType.EQUALS):
		var val_start := peek().start_pos
		var val_end := val_start
		while not check(GDT_Lexer.TokenType.NEWLINE) and not is_at_end():
			val_end = advance().end_pos
		
		return GDT_AST.VariableNode.new(
			type_str,
			name_token.value,
			val_start,
			val_end,
			annotations
		)

	return null


func match_token(type: GDT_Lexer.TokenType) -> bool:
	if check(type): advance(); return true
	return false
func match_keyword_flow(value: String) -> bool:
	if check(GDT_Lexer.TokenType.KEYWORD_FLOW) and peek().value == value: advance(); return true
	return false
func check(type: GDT_Lexer.TokenType) -> bool:
	if is_at_end(): return false
	return peek().type == type
func peek_next() -> GDT_Lexer.Token:
	if current + 1 >= tokens.size(): return null
	return tokens[current + 1]
func advance() -> GDT_Lexer.Token:
	if not is_at_end(): current += 1
	return previous()
func previous() -> GDT_Lexer.Token: return tokens[current - 1]
func is_at_end() -> bool: return peek().type == GDT_Lexer.TokenType.EOF
func peek() -> GDT_Lexer.Token: return tokens[current]
func consume(type: GDT_Lexer.TokenType, msg: String) -> GDT_Lexer.Token:
	if check(type): return advance()
	return peek()
