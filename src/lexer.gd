class_name GDT_Lexer
extends RefCounted

enum TokenType {
	KEYWORD_TYPE, KEYWORD_FLOW, IDENTIFIER, NUMBER, STRING,
	EQUALS, PLUS_EQUALS, PLUS, MINUS, SLASH,
	LPAREN, RPAREN, LBRACKET, RBRACKET, COLON, COMMA, DOT,
	INDENT, DEDENT, NEWLINE, EOF
}

class Token:
	var type: TokenType
	var value: String
	var start_pos: int # Where this token starts in the original text
	var end_pos: int   # Where this token ends
	
	func _init(t: TokenType, v: String, s: int, e: int):
		self.type = t
		self.value = v
		self.start_pos = s
		self.end_pos = e
		
	func _to_string() -> String:
		return "Token(%s, '%s')" % [TokenType.keys()[type], value]

const TYPE_KEYWORDS = ["void", "float", "int", "String", "array", "Vector2", "Vector3", "bool"]
const FLOW_KEYWORDS = ["extends", "for", "in", "return"]

func tokenize(source_code: String) -> Array[Token]:
	var tokens: Array[Token] = []
	var i := 0
	var length := source_code.length()
	var indent_stack: Array[int] = [0]
	var is_line_start := true
	var bracket_nesting_level := 0
	
	while i < length:
		var start := i
		var char = source_code[i]
		
		if char == "#":
			while i < length and source_code[i] != "\n" and source_code[i] != "\r":
				i += 1
			continue
		
		if is_line_start:
			var current_indent := 0
			while i < length and (source_code[i] == " " or source_code[i] == "\t"):
				current_indent += 4 if source_code[i] == "\t" else 1
				i += 1
			
			if i < length and (source_code[i] == "\n" or source_code[i] == "\r" or source_code[i] == "#"):
				if source_code[i] != "#": i += 1
				continue
				
			if bracket_nesting_level == 0:
				var last_indent: int = indent_stack.back()
				if current_indent > last_indent:
					indent_stack.append(current_indent)
					tokens.append(Token.new(TokenType.INDENT, str(current_indent), start, i))
				elif current_indent < last_indent:
					while indent_stack.back() > current_indent:
						indent_stack.pop_back()
						tokens.append(Token.new(TokenType.DEDENT, "", start, i))
			is_line_start = false
			continue
			
		if char == "\n" or char == "\r":
			if bracket_nesting_level == 0:
				tokens.append(Token.new(TokenType.NEWLINE, "\\n", start, i + 1))
			is_line_start = true
			i += 1
			continue
			
		if char == " " or char == "\t":
			i += 1
			continue
			
		if char == '"':
			var string_val := ""
			i += 1
			while i < length and source_code[i] != '"':
				string_val += source_code[i]
				i += 1
			if i < length: i += 1
			tokens.append(Token.new(TokenType.STRING, string_val, start, i))
			continue
			
		if char == ":" : tokens.append(Token.new(TokenType.COLON, ":", start, i+1)); i += 1; continue
		if char == "," : tokens.append(Token.new(TokenType.COMMA, ",", start, i+1)); i += 1; continue
		if char == "-" : tokens.append(Token.new(TokenType.MINUS, "-", start, i+1)); i += 1; continue
		if char == "/" : tokens.append(Token.new(TokenType.SLASH, "/", start, i+1)); i += 1; continue
		if char == "." : tokens.append(Token.new(TokenType.DOT, ".", start, i+1)); i += 1; continue
		
		if char == "(": tokens.append(Token.new(TokenType.LPAREN, "(", start, i+1)); bracket_nesting_level += 1; i += 1; continue
		if char == ")": tokens.append(Token.new(TokenType.RPAREN, ")", start, i+1)); bracket_nesting_level -= 1; i += 1; continue
		if char == "[": tokens.append(Token.new(TokenType.LBRACKET, "[", start, i+1)); bracket_nesting_level += 1; i += 1; continue
		if char == "]": tokens.append(Token.new(TokenType.RBRACKET, "]", start, i+1)); bracket_nesting_level -= 1; i += 1; continue
		
		if char == "+":
			if i + 1 < length and source_code[i + 1] == "=":
				tokens.append(Token.new(TokenType.PLUS_EQUALS, "+=", start, i+2))
				i += 2
			else:
				tokens.append(Token.new(TokenType.PLUS, "+", start, i+1))
				i += 1
			continue
			
		if char == "=":
			tokens.append(Token.new(TokenType.EQUALS, "=", start, i+1))
			i += 1
			continue
			
		if char.is_valid_int():
			var num_str := ""
			var has_dot := false
			while i < length and (source_code[i].is_valid_int() or source_code[i] == "."):
				if source_code[i] == ".":
					if has_dot: break
					has_dot = true
				num_str += source_code[i]
				i += 1
			tokens.append(Token.new(TokenType.NUMBER, num_str, start, i))
			continue
			
		if char.is_valid_identifier() or char == "_":
			var word := ""
			while i < length and (source_code[i].is_valid_identifier() or source_code[i] == "_" or source_code[i].is_valid_int()):
				word += source_code[i]
				i += 1
			if word in TYPE_KEYWORDS: tokens.append(Token.new(TokenType.KEYWORD_TYPE, word, start, i))
			elif word in FLOW_KEYWORDS: tokens.append(Token.new(TokenType.KEYWORD_FLOW, word, start, i))
			else: tokens.append(Token.new(TokenType.IDENTIFIER, word, start, i))
			continue
			
		i += 1
		
	while indent_stack.size() > 1:
		indent_stack.pop_back()
		tokens.append(Token.new(TokenType.DEDENT, "", i, i))
	tokens.append(Token.new(TokenType.EOF, "", i, i))
	return tokens
