package main

import "core:strconv"

CharSet :: distinct bit_set[u8(0)..<u8(128); u128]
Cs_Decimals :: CharSet{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
Cs_Alphas :: CharSet{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
Cs_SpaceTabs :: CharSet{' ', '\t'}
Cs_NewLine :: CharSet{'\n', '\r'}

Lexer :: struct {
    input: string,
    pos: int,
    whitespace: CharSet,
}

lex_ws :: proc(lexer: ^Lexer) -> string {
    return lex_chars(lexer, lexer.whitespace)
}

lex_chars :: proc(lexer: ^Lexer, chars: CharSet) -> string {
    if lexer.pos >= len(lexer.input) do return ""
    start_pos := lexer.pos
    for lexer.pos < len(lexer.input) && (lexer.input[lexer.pos] in chars) do lexer.pos += 1
    return lexer.input[start_pos:lexer.pos]
}

lex_int :: proc(lexer: ^Lexer, skip_ws: bool = true) -> (int, bool) {
    if skip_ws do lex_ws(lexer)
    num := lex_chars(lexer, Cs_Decimals)
    if num == "" do return 0, false
    return strconv.atoi(num), true
}

lex_expect_int :: proc(lexer: ^Lexer, skip_ws: bool = true) -> int {
    return lex_int(lexer, skip_ws) or_else panic("Not an int")
}

lex_eof :: proc(lexer: ^Lexer) -> bool {
    return lexer.pos >= len(lexer.input)
}