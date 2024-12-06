package main

import "core:fmt"

D6Tile :: enum { Empty, Wall, Visited, LoopWall }
D6TileSet :: bit_set[D6Tile]
D6Turn :: struct { pos, dir: int }

day6 :: proc(input: string) {
    N :: 130
    grid : [N * N]D6TileSet;
    guard := 0

    // Read grid
    lexer := Lexer{ input, 0, CharSet{ '.', '\n', '\r' } }
    loop: for {
        switch lex_maybe_ch(&lexer) or_else '$' {
        case '#': grid[lexer.pos - 1 - 2 * ((lexer.pos - 1) / (N + 2))] |= { .Wall }
        case '^': guard = lexer.pos - 1 - 2 * ((lexer.pos - 1) / (N + 2))
        case: break loop
        }
    }

    dirs := [?]int{-N, 1, N, -1}
    d := 0
    turns : [512]D6Turn
    turns_n := 0
    visited := 0
    loop_options := 0
    for {
        // Count visited positions
        if .Visited not_in grid[guard] {
            grid[guard] |= { .Visited }
            visited += 1
        }

        // Exit?
        if guard < N && d == 0 do break
        else if guard %% N == N - 1 && d == 1 do break
        else if guard >= N * N - N && d == 2 do break
        else if guard %% N == 0 && d == 3 do break

        // Turn?
        nxt := guard + dirs[d]
        if .Wall in grid[nxt] {
            turns[turns_n] = D6Turn { guard, d }; turns_n += 1
            d = (d + 1) %% len(dirs)
            continue
        }

        // Does putting wall here create a loop?
        if .Visited not_in grid[nxt] && .LoopWall not_in grid[nxt] {
            // Simulate; It's a loop if we eventually repeat a turn.
            // More than 4 turns may be needed.
            grid[nxt] += { .Wall }
            m := turns_n
            t_guard := guard
            t_d := (d + 1) %% len(dirs)
            loop_check: for {
                // Exit?
                if t_guard < N && t_d == 0 do break
                else if t_guard %% N == N - 1 && t_d == 1 do break
                else if t_guard >= N * N - N && t_d == 2 do break
                else if t_guard %% N == 0 && t_d == 3 do break

                // Turn?
                if .Wall in grid[t_guard + dirs[t_d]] {
                    // Repeated turn?
                    for i in 0..<m {
                        if turns[i].pos == t_guard && turns[i].dir == t_d {
                            grid[nxt] |= { .LoopWall }
                            loop_options += 1
                            break loop_check
                        }
                    }
                    turns[m] = D6Turn { t_guard, t_d }; m += 1
                    t_d = (t_d + 1) %% len(dirs)
                    continue
                }

                // Move
                t_guard += dirs[t_d]
            }
            grid[nxt] -= { .Wall }
        }

        // Move
        guard += dirs[d]
    }

    fmt.println("a:", visited)
    fmt.println("b:", loop_options)
}
