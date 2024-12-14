package main

import "core:fmt"
import "core:math"
import "core:math/linalg"

day13a :: proc(input: string) {
    lexer := Lexer{ input, 0, ~Cs_Decimals }
    res := 0
    for {
        ax := lex_maybe_int(&lexer) or_break
        ay := lex_int(&lexer)
        bx := lex_int(&lexer)
        by := lex_int(&lexer)
        px := lex_int(&lexer)
        py := lex_int(&lexer)
        if ax * by - bx * ay == 0 do continue
        mat := matrix[2, 2]f32{ f32(ax), f32(bx),
                                f32(ay), f32(by) }
        move := linalg.inverse(mat) * [2]f32{ f32(px), f32(py) }
        if move.x < 0 || 100 <= move.x || move.y < 0 || 100 <= move.y do continue
        rx := math.round(move.x)
        ry := math.round(move.y)
        if abs(move.x - rx) > 0.01 || abs(move.y - ry) > 0.01 do continue
        res += int(rx * 3 + ry)
    }
    fmt.println(res)
}

day13b :: proc(input: string) {
    lexer := Lexer{ input, 0, ~Cs_Decimals }
    res : i128 = 0
    for {
        ax := lex_maybe_int(&lexer) or_break
        ay := lex_int(&lexer)
        bx := lex_int(&lexer)
        by := lex_int(&lexer)
        px := lex_int(&lexer) + 10000000000000
        py := lex_int(&lexer) + 10000000000000
        if ax * by - bx * ay == 0 do continue
        mat := matrix[2, 2]f64{ f64(ax), f64(bx),
        f64(ay), f64(by) }
        move := linalg.inverse(mat) * [2]f64{ f64(px), f64(py) }
        rx := math.round(move.x)
        ry := math.round(move.y)
        if abs(move.x - rx) > 0.001 || abs(move.y - ry) > 0.001 do continue
        res += i128(rx * 3 + ry)
    }
    fmt.println(res)
}