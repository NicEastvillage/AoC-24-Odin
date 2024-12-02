package main

import "core:fmt"
import "core:text/scanner"
import "core:strconv"
import "core:slice/heap"

day1a :: proc(input: string) {

    less :: proc(a: int, b: int) -> bool {
        return a < b
    }

    N :: 1000
    left : [N]int = ---;
    right : [N]int = ---;

    lexer := Lexer{ input, 0, Cs_SpaceTabs | Cs_NewLine }

    for i in 0..<N {
        left[i] = lex_int(&lexer)
        heap.push(left[:i+1], less)

        right[i] = lex_int(&lexer)
        heap.push(right[:i+1], less)
    }

    sum := 0
    for i in 0..<N {
        sum += abs(left[0] - right[0])
        heap.pop(left[:N - i], less)
        heap.pop(right[:N - i], less)
    }

    fmt.println(sum)
}

day1b :: proc(input: string) {

    N :: 1000
    MIN :: 10_000
    MAX :: 100_000
    left : [MAX - MIN]i8;
    right : [MAX - MIN]i8;

    lexer := Lexer{ input, 0, Cs_SpaceTabs | Cs_NewLine }

    sum := 0
    for i in 0..<N {
        l := lex_int(&lexer)
        left[l - MIN] += 1;
        sum += l * int(right[l - MIN])

        r := lex_int(&lexer)
        right[r - MIN] += 1;
        sum += r * int(left[r - MIN])
    }

    fmt.println(sum)
}
