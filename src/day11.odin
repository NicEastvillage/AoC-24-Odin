package main

import "core:fmt"

day11 :: proc(input: string, $BLINKS: int) {
    // Key in map: current stone engraving.
    // Index *i*: number of stones after *i* + 1 blinks. Value of 0 implies unknown.
    cache := make(map[int][BLINKS]int, 4096) // Leaked
    calc :: proc(val: int, blinks_left: int, cache: ^map[int][BLINKS]int) -> int {
        if blinks_left == 0 do return 1
        if val not_in cache do cache[val] = [BLINKS]int{}
        arr := &cache[val]
        if arr[blinks_left - 1] > 0 do return arr[blinks_left - 1]

        k := 0
        if val == 0 do k = calc(1, blinks_left - 1, cache)
        else if 10 <= val && val < 100 {
            k += calc(val / 10, blinks_left - 1, cache)
            k += calc(val %% 10, blinks_left - 1, cache)
        } else if 1000 <= val && val < 10_000 {
            k += calc(val / 100, blinks_left - 1, cache)
            k += calc(val %% 100, blinks_left - 1, cache)
        } else if 100_000 <= val && val < 1_000_000 {
            k += calc(val / 1_000, blinks_left - 1, cache)
            k += calc(val %% 1_000, blinks_left - 1, cache)
        } else if 10_000_000 <= val && val < 100_000_000 {
            k += calc(val / 10_000, blinks_left - 1, cache)
            k += calc(val %% 10_000, blinks_left - 1, cache)
        } else if 1_000_000_000 <= val && val < 10_000_000_000 {
            k += calc(val / 100_000, blinks_left - 1, cache)
            k += calc(val %% 100_000, blinks_left - 1, cache)
        } else if 100_000_000_000 <= val && val < 1_000_000_000_000 {
            k += calc(val / 1_000_000, blinks_left - 1, cache)
            k += calc(val %% 1_000_000, blinks_left - 1, cache)
        } else if 100_000_000_000_000 < val {
            fmt.println(val)
            panic("BIGGER INTERVALS NEEDED")
        } else {
            k = calc(val * 2024, blinks_left - 1, cache)
        }

        arr2 := &cache[val] // New access since cache may have reallocated
        arr2[blinks_left - 1] = k
        return k
    }

    lexer := Lexer{ input, 0, Cs_SpaceTabs }
    res := 0
    for do res += calc(lex_maybe_int(&lexer) or_break, BLINKS, &cache)
    fmt.println(res)
}
