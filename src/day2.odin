package main

import "core:fmt"

day2a :: proc(input: string) {
    lexer := Lexer{ input, 0, Cs_SpaceTabs }
    safe := 0

    line_loop: for !lex_eof(&lexer) {
        defer { lex_to_next_line(&lexer) }
        first := lex_int(&lexer)
        prev := lex_int(&lexer)

        dir := 0
        switch {
        case first == prev: continue line_loop
        case abs(first - prev) > 3: continue line_loop
        case first < prev: dir = 1
        case first > prev: dir = -1
        }

        for {
            num := lex_maybe_int(&lexer) or_break
            if (num - prev + 2 * dir) / 3 != dir do continue line_loop
            prev = num
        }

        safe += 1
    }

    fmt.println(safe)
}

day2b :: proc(input: string) {
    lexer := Lexer{ input, 0, Cs_SpaceTabs }
    report : [8]int = ---;
    safe := 0
    line_loop: for !lex_eof(&lexer) {
        defer { lex_to_next_line(&lexer) }
        n := 0
        for n < 8 {
            report[n] = lex_maybe_int(&lexer) or_break
            n += 1
        }
        if i := find_error(report[:n], -1); i != -1 {
            // Last case with skip=0 is require for report 20 22 21 19. Err at 21, but 20 is the culprit
            if find_error(report[:n], i) != -1 && find_error(report[:n], i - 1) != -1 && find_error(report[:n], 0) != -1 {
                continue
            }
        }
        safe += 1
    }
    fmt.println(safe)
}

find_error :: proc(report: []int, skip: int) -> int {
    i := skip != 0 ? 0 : 1
    first := report[i]; i += 1
    if skip == i do i += 1
    prev := report[i]; i += 1

    dir := 0
    switch {
    case first == prev: return i - 1
    case abs(first - prev) > 3: return i - 1
    case first < prev: dir = 1
    case first > prev: dir = -1
    }

    for i < len(report) {
        if skip == i {
            i += 1
            continue
        }
        num := report[i]; i += 1
        if (num - prev + 2 * dir) / 3 != dir do return i - 1
        prev = num
    }

    return -1
}
