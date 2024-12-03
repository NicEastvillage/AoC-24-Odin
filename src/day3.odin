package main

import "core:fmt"
import "core:strings"

day3a :: proc(input: string) {
    lexer := Lexer{ input, 0, CharSet{} }
    sum := 0
    for {
        lex_jump_to_after_seq(&lexer, "mul") or_break
        lex_maybe_ch(&lexer, '(') or_continue
        fst := lex_maybe_int(&lexer) or_continue
        lex_maybe_ch(&lexer, ',') or_continue
        snd := lex_maybe_int(&lexer) or_continue
        lex_maybe_ch(&lexer, ')') or_continue
        sum += fst * snd
    }
    fmt.println(sum)
}

day3b :: proc(input: string) {
    lexer := Lexer{ input, 0, CharSet{} }
    enabled := true
    sum := 0
    for {
        skipped := lex_jump_to_after_seq(&lexer, "mul") or_break
        if d := strings.last_index(skipped, "do()") - strings.last_index(skipped, "don't()"); d != 0 {
            enabled = d > 0
        }
        enabled or_continue
        lex_maybe_ch(&lexer, '(') or_continue
        fst := lex_maybe_int(&lexer) or_continue
        lex_maybe_ch(&lexer, ',') or_continue
        snd := lex_maybe_int(&lexer) or_continue
        lex_maybe_ch(&lexer, ')') or_continue
        sum += fst * snd
    }
    fmt.println(sum)
}
