package main

import "core:fmt"
import "core:slice"

D5Set :: distinct bit_set[0..<128; u128]

d5_cmp :: proc(a, b: int) -> slice.Ordering {
    succ := cast([^]D5Set)context.user_ptr
    switch {
    case b in succ[a]: return .Less
    case a in succ[b]: return .Greater
    case: return .Equal
    }
}

day5 :: proc(input: string) {
    succ : [100]D5Set
    lexer := Lexer{ input, 0, CharSet{'|', ','}}
    for {
        fst := lex_maybe_int(&lexer) or_break
        succ[fst] |= D5Set{ lex_int(&lexer) }
        lex_to_next_line(&lexer)
    }
    lex_to_next_line(&lexer)

    seq : [25]int
    n, res_a, res_b : int
    for {
        seq[0] = lex_maybe_int(&lexer) or_break; n := 1
        for {
            seq[n] = lex_maybe_int(&lexer) or_break; n += 1
        }

        ok := true
        disallow := D5Set{}
        for i := n-1; i >= 0; i -= 1 {
            if seq[i] in disallow {
                ok = false
                break
            }
            disallow |= succ[seq[i]]
        }

        if ok {
            res_a += seq[n / 2]
        } else {
            context.user_ptr = &succ
            slice.sort_by_cmp(seq[:n], d5_cmp)
            res_b += seq[n / 2]
        }

        lex_to_next_line(&lexer)
    }

    fmt.println("a:", res_a)
    fmt.println("b:", res_b)
}
