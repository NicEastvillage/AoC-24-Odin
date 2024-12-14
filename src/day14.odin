package main

import "core:fmt"

day14a :: proc(input: string) {
    N :: 500
    W :: 101
    H :: 103
    lexer := Lexer{ input, 0, ~(Cs_Decimals | { '-' }) }
    quadrants : [4]int
    for _ in 0..<N {
        x := lex_int(&lexer)
        y := lex_int(&lexer)
        ex := (x + 100 * lex_signed_int(&lexer)) %% W
        ey := (y + 100 * lex_signed_int(&lexer)) %% H
        switch {
        case ex < W / 2 && ey < H / 2: quadrants[0] += 1
        case ex > W / 2 && ey < H / 2: quadrants[1] += 1
        case ex < W / 2 && ey > H / 2: quadrants[2] += 1
        case ex > W / 2 && ey > H / 2: quadrants[3] += 1
        }
    }
    fmt.println(quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3])
}

day14b :: proc(input: string) {
    fmt.println("Lmao")
}