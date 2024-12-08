package main

import "core:fmt"
import "core:slice"

day8a :: proc(input: string) {
    SIZE :: 50
    antinodes : [SIZE][SIZE]bool
    buffer : [256][8][2]int = ---
    antenna : [256][dynamic][2]int = ---
    for i in 0..<256 do antenna[i] = slice.into_dynamic(buffer[i][:])
    lexer := Lexer{ input, 0, { '.' } }
    res := 0
    for x in 0..<SIZE {
        for {
            ant := lex_maybe_ch(&lexer) or_break
            pos := [?]int{ x, (lexer.pos - 1) %% (SIZE + 2) }
            for other in antenna[ant] {
                diff := pos - other
                anti_1 := pos + diff
                anti_2 := other - diff
                if 0 <= anti_1.x && anti_1.x < SIZE && 0 <= anti_1.y && anti_1.y < SIZE && !antinodes[anti_1.y][anti_1.x] {
                    res += 1
                    antinodes[anti_1.y][anti_1.x] = true
                }
                if 0 <= anti_2.x && anti_2.x < SIZE && 0 <= anti_2.y && anti_2.y < SIZE && !antinodes[anti_2.y][anti_2.x] {
                    res += 1
                    antinodes[anti_2.y][anti_2.x] = true
                }
            }
            append(&antenna[ant], pos)
        }
        lex_to_next_line(&lexer)
    }
    fmt.println(res)
}

day8b :: proc(input: string) {
    SIZE :: 50
    antinodes : [SIZE][SIZE]bool
    buffer : [256][8][2]int = ---
    antenna : [256][dynamic][2]int = ---
    for i in 0..<256 do antenna[i] = slice.into_dynamic(buffer[i][:])
    lexer := Lexer{ input, 0, { '.' } }

    res := 0
    for x in 0..<SIZE {
        for {
            ant := lex_maybe_ch(&lexer) or_break
            pos := [?]int{ x, (lexer.pos - 1) %% (SIZE + 2) }
            for other in antenna[ant] {
                diff := pos - other
                span := 1 + SIZE / max(abs(diff.x), abs(diff.y))
                for steps in -span..<span {
                    antipos := pos - diff * steps
                    if 0 <= antipos.x && antipos.x < SIZE && 0 <= antipos.y && antipos.y < SIZE && !antinodes[antipos.y][antipos.x] {
                        res += 1
                        antinodes[antipos.y][antipos.x] = true
                    }
                }
            }
            append(&antenna[ant], pos)
        }
        lex_to_next_line(&lexer)
    }
    fmt.println(res)
}