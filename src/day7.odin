package main

import "core:fmt"
import "core:math"

day7a :: proc(input: string) {
    lexer := Lexer{ input, 0, { ' ', ':' } }
    nums : [16]int
    res := 0
    for {
        n := uint(0)
        goal := lex_maybe_int(&lexer) or_break
        for { nums[n] = lex_maybe_int(&lexer) or_break; n += 1 }
        for perm in 0..<1 << (n - 1) {
            val := nums[0]
            for i in 0 ..< n - 1 {
                if val > goal do break
                if (perm >> i) & 1 == 0 {
                    val += nums[1 + i]
                } else {
                    val *= nums[1 + i]
                }
            }
            if val == goal {
                res += goal
                break
            }
        }
        lex_to_next_line(&lexer)
    }

    fmt.println(res)
}

day7b :: proc(input: string) {
    lexer := Lexer{ input, 0, { ' ', ':' } }
    nums : [16]int
    res := 0
    for {
        n := uint(0)
        goal := lex_maybe_int(&lexer) or_break
        for { nums[n] = lex_maybe_int(&lexer) or_break; n += 1 }

        test_rec :: proc(val: int, nums: []int, goal: int) -> bool {
            if len(nums) == 0 do return val == goal
            if val > goal do return false
            @(static) digits_lut := [?]int{ 0..<10 = 10, 10..<100 = 100, 100..<1000 = 1000 }
            return test_rec(val + nums[0], nums[1:], goal) || test_rec(val * nums[0], nums[1:], goal) || test_rec(val * digits_lut[nums[0]] + nums[0], nums[1:], goal)
        }

        if test_rec(nums[0], nums[1:n], goal) do res += goal

        lex_to_next_line(&lexer)
    }

    fmt.println(res)
}
