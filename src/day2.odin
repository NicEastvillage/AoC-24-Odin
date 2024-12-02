package main

import "core:fmt"

day2a :: proc(input: string) {
    lexer := Lexer{ input, 0, Cs_SpaceTabs }
    safe := 0

    line_loop: for !lex_eof(&lexer) {
        defer { lex_chars(&lexer, ~Cs_NewLine); lex_chars(&lexer, Cs_NewLine) }
        first := lex_expect_int(&lexer)
        prev := lex_expect_int(&lexer)

        dir := 0
        switch {
        case first == prev: continue line_loop
        case abs(first - prev) > 3: continue line_loop
        case first < prev: dir = 1
        case first > prev: dir = -1
        }

        for {
            num := lex_int(&lexer) or_break
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
        defer { lex_chars(&lexer, ~Cs_NewLine); lex_chars(&lexer, Cs_NewLine); }
        n := 0
        for n < 8 {
            report[n] = lex_int(&lexer) or_break
            n += 1
        }
        for i := 0; i < n; i += 1 {
            if is_safe_w_skip(report[0:n], i) {
                safe += 1
                break
            }
        }
    }
    fmt.println(safe)
}

is_safe_w_skip :: proc(report: []int, skip: int) -> bool {
    i := skip != 0 ? 0 : 1
    first := report[i]; i += 1
    if skip == i do i += 1
    prev := report[i]; i += 1

    dir := 0
    switch {
    case first == prev: return false
    case abs(first - prev) > 3: return false
    case first < prev: dir = 1
    case first > prev: dir = -1
    }

    for i < len(report) {
        if skip == i {
            i += 1
            continue
        }
        num := report[i]; i += 1
        if (num - prev + 2 * dir) / 3 != dir do return false
        prev = num
    }

    return true
}
