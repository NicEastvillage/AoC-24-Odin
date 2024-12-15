package main

import "core:fmt"
import "core:os"

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
    N :: 500
    W :: 101
    H :: 103
    Robot :: struct { pos, vel: [2]int }
    lexer := Lexer{ input, 0, ~(Cs_Decimals | { '-' }) }
    robots : [N]Robot = ---
    for i in 0..<N {
        robots[i] = Robot{
            pos = { lex_int(&lexer), lex_int(&lexer) },
            vel = { lex_signed_int(&lexer), lex_signed_int(&lexer) },
        }
    }
    buf : [1]byte
    grid := [H][W]byte{ 0..<H = { 0..<W = '0' } }
    for &r in robots do grid[r.pos.y][r.pos.x] += 1
    steps := 0
    simulate: for {
        steps += 1
        for &r in robots {
            grid[r.pos.y][r.pos.x] -= 1
            r.pos += r.vel
            r.pos.x %%= W
            r.pos.y %%= H
            grid[r.pos.y][r.pos.x] += 1
        }
        K :: 12
        for i in 30..<H-30 {
            for j in 15..<W-15-K {
                ok := true
                for k in 0..<K {
                    if grid[i][j+k] == '0' {
                        ok = false
                        break
                    }
                }
                if ok do break simulate
            }
        }
    }
    for i in 0..<H {
        fmt.println(string(grid[i][:]))
    }
    fmt.println(steps)
}